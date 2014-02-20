class Users::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token

  def create
    self.resource = warden.authenticate!(auth_options)
    unless resource
      set_flash_message(:user_login_error, 'invalid' )
      redirect_to :back and return
    end

    if is_navigational_format?
      if resource.sign_in_count == 1
        set_flash_message(:notice, :signed_in_first_time)
      else
        set_flash_message(:notice, :signed_in)
      end
    end
    sign_in(resource)
    yield resource if block_given?

    if session[:referer].present?
      redirect_to session[:referer]
      session[:referer] = nil
    else
      redirect_to resource.skills.blank? ? user_interests_path(resource) : user_path(resource)
    end
  end

  def new
    session[:referer] = request.referer.to_s if request.referer.present?

    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
end