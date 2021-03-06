class Users::RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource({})
    respond_with resource
  end

  def create
    self.resource = resource_class.new(sign_up_params)

    resource.pro_account_enabled = true
    resource.pro_account_due = Time.now + 90.days

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        UserMailer.async_send(:welcome, resource.id)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash[:registration_errors] = resource.errors and redirect_to :back
    end
  end
end