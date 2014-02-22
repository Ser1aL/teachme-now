module Admin

  def verify_access
    redirect_to new_admin_sessions_path if session[:admin].blank?
  end

end