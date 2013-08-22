class TeachersController < ApplicationController

  def index
    user_ids = Share.where(share_type: 'teach').group(:user_id).map(&:user_id)
    @teachers = Kaminari.paginate_array(User.find(user_ids)).page(params[:page]).per(8)
  end

  def search
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
    render :index
  end
end
