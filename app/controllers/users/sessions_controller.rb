class Users::SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    if is_navigational_format?
      if resource.sign_in_count == 1
        set_flash_message(:notice, :signed_in_first_time)
      else
        set_flash_message(:notice, :signed_in)
      end
    end
    sign_in(resource_name, resource)

    if session[:referer].present?
      redirect_to session[:referer]
      session[:referer] = nil
    else
      redirect_to resource.skills.blank? ? user_interests_path(resource) : user_path(resource)
    end
  end

  def new
    session[:referer] = request.referer.to_s if request.referer.present?
    self.resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
end