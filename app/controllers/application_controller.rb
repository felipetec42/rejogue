class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  before_action :store_user_location!, if: :storable_location?


  def after_sign_out_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    request.referer || stored_location_for(resource_or_scope)
  end

  def after_update_path_for(resource_or_scope)
		stored_location_for(resource_or_scope) || root_path
	end

  private

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

end
