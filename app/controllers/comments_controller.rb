class CommentsController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json

  def create
    @comment = Comment.create(params[:comment].merge({ user_id: current_user.id }))
    if @comment.new_record?
      render json: false
    else
      render @comment
    end
  end

end
