class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :update_current_user
  before_filter :set_dev, :redirect_if_not_released
  before_filter :preload_interest_tree

  private

  def update_current_user
    current_user.try :touch
  end

  def preload_interest_tree
    @interests = Interest.includes(:sub_interests)
  end

  def redirect_if_not_released
    unless Rails.env.development?
      redirect_to '/greet' if session['dev'].blank? && params[:action] != 'greet'
    end
  end

  def set_dev
    session['dev'] = 'dev login' if params[:let_me_in]
  end

end
