class Identity
# -----------------------------------------------------------------------------------------------------------
# Database
	include Mongoid::Document
	include Mongoid::Timestamps

	field :oauth_token, type: String
	field :oauth_expires_at, type: String
	field :email, type: String
	field :image, type: String
	field :name, type: String
	field :nickname, type: String
	field :provider, type: String
	field :uid, type: String
	field :urls, type: String

# -----------------------------------------------------------------------------------------------------------
# Model

	# Relations
	belongs_to :user

	# Validations
	validates_presence_of :uid, :provider
	validates_uniqueness_of :uid, :scope => :provider

# -----------------------------------------------------------------------------------------------------------
# Class Methods

	def self.find_for_oauth(auth)
		identity = where(provider: auth.provider, uid: auth.uid).first
		identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
		identity.oauth_token = auth.credentials.token
		identity.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
		identity.name = auth.info.name
		identity.email = auth.info.email
		if auth.provider == "instagram"
			identity.nickname = auth.info.nickname
			identity.urls = auth.info.website
		else
			identity.nickname = auth.extra.raw_info.name
			identity.urls = (auth.info.urls || "").to_json
		end
		identity.save
		identity
	end

	def self.find_for_oauth_mobile(auth)
		identity = where(provider: "facebook", uid: auth[:uid]).first
		identity = create(uid: auth[:uid], provider: "facebook") if identity.nil?
		identity.oauth_token = auth[:token]
		identity.oauth_expires_at = Time.at(auth[:expires_at]) if auth[:expires_at].present?
		identity.name = auth[:name]
		identity.email = auth[:email]
		identity.save
		identity
	end

	rails_admin do
		# Hide from Dashboard and Side Menu
		visible false
		list do
		field :name
		end
	end

end
