class Users::PasswordsController < Devise::PasswordsController
  layout "public"


protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    return render nothing: true, status: :ok
  end

  def after_resetting_password_path_for(resource)
    customer_perfil_index_path
  end

end
