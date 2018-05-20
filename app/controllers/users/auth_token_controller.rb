class Users::AuthTokenController < ApplicationController

  def index
    @user = User.where(authentication_token: params[:q], email: params[:e]).first
    return redirect_back(fallback_location: root_path) unless @user

    sign_in @user
    return redirect_to root_path
  end
end
