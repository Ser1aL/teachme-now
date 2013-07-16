class CommentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_commentable
  respond_to :json

  def create
    @comment = @commentable.comments.new(params[:comment].merge({ user_id: current_user.id }))
    if @comment.save
      render @comment
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end

private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end
