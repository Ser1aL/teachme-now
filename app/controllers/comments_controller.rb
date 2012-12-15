class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def create
    Comment.create(params[:comment].merge({ user_id: current_user.id })) and redirect_to :back
  end

end
