class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    begin
      @already_user = User.find_by(username: user_params[:username]) rescue nil
      @user = User.new(username: user_params[:username], email: user_params[:email], password: user_params[:password])
      @user.save!
      if @user.persisted?
        sign_in @user
        redirect_to logged_home_index_path, notice:  "Bem vindo!"
      else
        respond_to do |format|
          format.html {
            render :new, alert: "Houve algum erro."
          }
          format.json {
            render json: {error: true, message: "Houve algum erro."}, status: :bad_request
          }
        end
      end
    rescue Exception => e
      puts e.to_json
      respond_to do |format|
        format.html {
          render :new, alert: e.message
        }
        format.json {
          render json: {error: true, message: e.message}, status: :bad_request
        }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :accept_terms_and_conditions)
  end
end
