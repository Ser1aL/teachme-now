class Users::PasswordsController < Devise::PasswordsController

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash[:restore_errors] = resource.errors and redirect_to :back
    end
  end

end