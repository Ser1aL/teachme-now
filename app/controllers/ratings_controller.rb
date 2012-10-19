class RatingsController < ApplicationController

  before_filter :authenticate_user!, :prepare_ratings
  respond_to :json

  def create
    @rating.increment!(:rating)
    render json: { rating: @taker.ratings.sum(&:rating) }, layout: false
  end

  def update
    @rating.decrement!(:rating)
    render json: { rating: @taker.ratings.sum(&:rating) }, layout: false
  end

  private

  def prepare_ratings
    @taker = User.find(params[:user_id])
    @taker.ratings.where('giver_id = ?', current_user.id).destroy_all
    @rating = Rating.find_or_create_by_giver_id_and_taker_id(current_user.id, @taker.id)
  end
end
