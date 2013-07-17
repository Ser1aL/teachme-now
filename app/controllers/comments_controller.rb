class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @comment = Comment.create(params[:comment].merge({ user_id: current_user.id }))
    if @comment.new_record?
      render json: { errors: @comment.errors.full_messages }
    else
      render @comment
    end
  end

end
