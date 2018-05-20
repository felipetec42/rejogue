class SessionsController < Devise::SessionsController

  respond_to :json

  def create
    user = User.where(username: params[:user][:username]).first
    return invalid_login_attempt("email_invalid", "login-email") unless user
    if user.valid_password?(params[:user][:password])
      sign_in :user, user
      redirect_to logged_home_index_path
      return
    end
    invalid_login_attempt("password_invalid", "login-senha")
  end

  def invalid_login_attempt(message, key)
    set_flash_message(:alert, message)
    result = {
      key: key,
      message: flash[:alert],
      authenticity_token: form_authenticity_token
    }
    render json: result, status: 401
    flash.clear
  end

end
