class UserConnectionsController < ApplicationController

  before_filter :authenticate_user!, :prepare_leader_and_follower

  def create
    UserConnection.find_or_create_by_leader_id_and_follower_id(@leader.id, @follower.id)
    render text: '1'
  end

  def destroy
    UserConnection.where(leader_id: @leader.id, follower_id: @follower.id).first.try(:destroy)
    render text: '1'
  end

  private

  def prepare_leader_and_follower
    if params[:connection_type].try(:to_sym) == :leaders
      @leader = User.find(params[:user_id])
      @follower = current_user
    elsif params[:connection_type].try(:to_sym) == :followers
      @leader = current_user
      @follower = User.find(params[:user_id])
    else
      @leader = User.find(params[:user_id])
      @follower = current_user
    end
  end

end