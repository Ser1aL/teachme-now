module Administratable
  extend ActiveSupport::Concern

  included do
    layout 'admin'

    helper_method :admin_loginned?
  end

  def verify_access
    redirect_to new_admin_session_path if session[:admin].blank?
  end

  def set_admin_loginned
    session[:admin] = 'successful'
  end

  def admin_loginned?
    session[:admin] == 'successful'
  end

  def destroy_session
    session[:admin] = nil
  end

end