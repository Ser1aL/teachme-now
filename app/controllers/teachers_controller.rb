class TeachersController < ApplicationController

  def index
    order, reverse = params[:order].try(:split, ' ') || :teacher_rating

    teachers = User.find_teachers_info
    teachers.each{|teacher| teacher.teacher_rating = 0 if teacher.teacher_rating == nil}

    if current_user
      teachers.sort_by!(&:teacher_rating).reverse!.each do |teacher|
        @current_user_rank = teachers.index(teacher) + 1 if teacher.id == current_user.id
      end
    end

    @teachers_count = teachers.size

    teachers.sort_by!(&order.to_sym).reverse!
    teachers.reverse! if reverse
    @teachers = Kaminari.paginate_array(teachers).page(params[:page]).per(8)
  end

  def search
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
    render :index
  end
end
