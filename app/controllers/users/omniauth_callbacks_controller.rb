class Users::OmniauthCallbacksController < ApplicationController

  def facebook
    current_user = User.oauth_find_or_create(:facebook, request.env['omniauth.auth'])
    sign_in current_user
    redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
  end

  def vkontakte
    current_user = User.oauth_find_or_create(:vkontakte, request.env['omniauth.auth'], params[:code])
    sign_in current_user
    render 'users/vk_close_window'
  end

  def vkontakte_transitional
    redirect_to root_path and return unless current_user
    if current_user.email.ends_with?('@vk.com')
      redirect_to user_update_email_path(current_user)
    else
      redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
    end
  end

  def failure
    # TODO
    # create fallback page
    redirect_to new_user_session_path
  end
end