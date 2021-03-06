class Users::OmniauthCallbacksController < ApplicationController

  def facebook
    current_user = User.oauth_find_or_create(:facebook, request.env['omniauth.auth'])
    sign_in current_user

    if session[:referer].present? && ![new_user_session_url, root_url].include?(session[:referer])
      redirect_to session[:referer]
      session[:referer] = nil
    else
      redirect_to current_user.skills.blank? ? user_interests_path(current_user) : user_path(current_user)
    end
  end

  def vkontakte
    current_user = User.oauth_find_or_create(:vkontakte, request.env['omniauth.auth'], params[:code])
    sign_in current_user
    render 'users/vk_close_window', layout: false
  end

  def vkontakte_transitional
    redirect_to new_user_session_path and return unless current_user
    if session[:referer].present? && ![new_user_session_url, root_url].include?(session[:referer])
      redirect_to session[:referer]
      session[:referer] = nil
    elsif current_user.email.ends_with?('@vk.com')
      redirect_to edit_user_path(current_user)
    else
      redirect_to current_user.skills.blank? ? user_interests_path(current_user) : user_path(current_user)
    end
  end

  def failure
    # TODO
    # create fallback page
    if params[:error]
      render 'users/vk_close_window', layout: false
    else
      redirect_to new_user_session_path
    end

  end
end