class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @comment = Comment.create(comment_params.merge({ user_id: current_user.id }))
    if @comment.new_record?
      render json: { errors: @comment.errors.full_messages }
    else
      @comment.create_message_notifications!(current_user)
      render @comment
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:lesson_id, :body)
  end

end
