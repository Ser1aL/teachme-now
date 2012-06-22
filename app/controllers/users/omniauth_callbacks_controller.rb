class Users::OmniauthCallbacksController < ApplicationController


  def facebook
    current_user = User.oauth_find_or_create(:facebook, request.env['omniauth.auth'])
    sign_in current_user
    redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
  end

  def vkontakte
    current_user = User.oauth_find_or_create(:vkontakte, request.env['omniauth.auth'])
    sign_in current_user
    redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
  end

  def failure
    # TODO
    # create fallback page
  end
end