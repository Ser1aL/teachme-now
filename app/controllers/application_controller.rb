class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :update_current_user

  private

  def update_current_user
    current_user.try :touch
  end

end
