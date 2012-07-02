class InterestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @interests = Interest.includes(:sub_interests)
    @selected_interests = current_user.skills.includes(:sub_interest).map(&:sub_interest)
  end
end
