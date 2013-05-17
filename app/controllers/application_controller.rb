class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :update_current_user
  before_filter :preload_interest_tree

  private

  def update_current_user
    current_user.try :touch
  end

  def preload_interest_tree
    @interests = Interest.includes(:sub_interests)
  end

end
