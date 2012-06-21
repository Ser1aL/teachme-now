class Users::OmniauthCallbacksController < ApplicationController

  def facebook
    current_user = User.oauth_find_or_create(:facebook, request.env['omniauth.auth'])
    sign_in_and_redirect current_user, event: :authentication
  end

  def vkontakte
    current_user = User.oauth_find_or_create(:vkontakte, request.env['omniauth.auth'])
    sign_in_and_redirect current_user, event: :authentication
  end

  def failure
    # TODO
    # create fallback page
  end
end