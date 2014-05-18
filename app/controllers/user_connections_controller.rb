class UserConnectionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    UserConnection.where(leader_id: params[:user_id], follower_id: current_user.id).first_or_create!
    redirect_to :back
  end

  def destroy
    UserConnection.where(leader_id: params[:user_id], follower_id: current_user.id).first.try(:destroy)
    redirect_to :back
  end

end