class UserConnectionsController < ApplicationController

  # respond_to :json
  before_filter :authenticate_user!, :prepare_leader

  def create
    if !current_user.leaders.include?(@leader) && @leader != current_user
      UserConnection.create(leader: @leader, follower: current_user)
    end
    render text: 'Unsubscribe'
  end

  def destroy
    UserConnection.where(leader_id: @leader.id, follower_id: current_user.id).first.try(:destroy)
    render text: 'Subscribe'
  end

  private

  def prepare_leader
    @leader = User.find params[:user_id]
  end

end