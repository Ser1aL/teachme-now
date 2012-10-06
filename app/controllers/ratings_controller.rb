class RatingsController < ApplicationController

  before_filter :authenticate_user!

  def create
    Rating.find_or_create_by_giver_id_and_taker_id current_user.id, User.find(params[:user_id]).id
    render text: 'Vote down'
  end

  def update
    Rating.find_by_giver_id_and_taker_id(current_user.id, User.find(params[:user_id]).id).destroy
    render text: 'Vote up'
  end
end
