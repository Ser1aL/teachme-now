class InterestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @interests = Interest.includes(:sub_interests)
  end
end
