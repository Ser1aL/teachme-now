class RatingsController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json

  def create
    taker = User.find(params[:user_id])
    Rating.find_or_create_by_giver_id_and_taker_id current_user.id, taker.id
    render json: { rating: taker.ratings.size }, layout: false
  end

  def update
    taker = User.find(params[:user_id])
    Rating.find_by_giver_id_and_taker_id(current_user.id, taker.id).destroy
    render json: { rating: taker.ratings.size }, layout: false
  end
end
