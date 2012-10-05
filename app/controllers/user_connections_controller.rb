class UserConnectionsController < ApplicationController

  respond_to :json
  before_filter :authenticate_user!, :prepare_leader

  def create
    if !current_user.leaders.include?(@leader) && @leader != current_user
      UserConnection.create(leader: @leader, follower: current_user)
    end
    # respond_with [{ status: :ok }]
    redirect_to :back
  end

  def destroy
    # @leader.followers.select{ |follower| follower == current_user }.try(:compact).each(&:destroy)
    # UserConnection.where(leader: @leader, follower: current_user)
    # respond_with [{ status: :ok }]
    redirect_to :back
  end

  private

  def prepare_leader
    @leader = User.find params[:user_id]
  end

end
