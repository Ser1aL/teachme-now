class UserConnectionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    UserConnection.find_or_create_by_leader_id_and_follower_id(params[:user_id], current_user.id)
    redirect_to :back
  end

  def destroy
    UserConnection.where(leader_id: params[:user_id], follower_id: current_user.id).first.try(:destroy)
    redirect_to :back
  end

end