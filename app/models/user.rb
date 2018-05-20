class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name,                       type: String
  field :username,                   type: String

  # Devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :recoverable, :timeoutable, :timeout_in => 7.days
  validates_confirmation_of :password

  ## Token Authenticatable
  acts_as_token_authenticatable
  field :authentication_token

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""


  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  field :failed_login_attempts, type: Integer, default: 0
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time
  field :view_version_ab, type: String

  has_many :identities, dependent: :destroy, autosave: true

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    user = User.where(email: identity.email).first unless user

    # Create the user if needed
    if user.nil?
      user = User.newWithRole({}, 'customer')
      name_split = auth.info.name.split(' ')
      if name_split.count > 1
        name = name_split.first
        last_name = name_split.last
      else
        name = name_split.first
        last_name = ''
      end
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = name
      user.last_name = last_name
      user.remote_user_image_url =  auth.extra.raw_info.picture.data.url
      user.identities << identity
      user.skip_validations = true
      user.save!
    end

    # Associate the identity with the user
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

end
