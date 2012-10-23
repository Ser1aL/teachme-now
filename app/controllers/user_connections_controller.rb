class UserConnectionsController < ApplicationController

  # respond_to :json
  before_filter :authenticate_user!, :prepare_leader_and_follower

  def create
    UserConnection.create(leader: @leader, follower: @follower)
    render text: '1'
  end

  def destroy
    UserConnection.where(leader_id: @leader.id, follower_id: @follower.id).first.try(:destroy)
    render text: '1'
  end

  private

  def prepare_leader_and_follower
    if params[:connection_type].to_sym == :leaders
      @leader = User.find(params[:user_id])
      @follower = current_user
    else
      @leader = current_user
      @follower = User.find(params[:user_id])
    end
  end

end