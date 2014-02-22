class Admin::SessionsController < ApplicationController

  include Administratable

  def new
    redirect_to admin_lessons_path if admin_loginned?
  end

  def create
    if params[:login] == Teachme.app_config.admin_login
      if params[:password] == Teachme.app_config.admin_password
        set_admin_loginned and redirect_to admin_lessons_path
      else
        flash[:alert] = I18n.t('admin.password_wrong') and redirect_to new_admin_session_path
      end
    else
      flash[:alert] = I18n.t('admin.login_wrong') and redirect_to new_admin_session_path
    end
  end

  def sign_out
    destroy_session
    redirect_to root_path
  end
end