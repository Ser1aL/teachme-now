class TeachersController < ApplicationController

  before_filter :set_order, :verify_acceptable_order

  def index
    teachers = User.find_teachers_info
    teachers.each{|teacher| teacher.teacher_rating = 0 if teacher.teacher_rating == nil}

    if current_user
      teachers.sort_by!(&:teacher_rating).reverse!.each do |teacher|
        @current_user_rank = teachers.index(teacher) + 1 if teacher.id == current_user.id
      end
    end

    @teachers_count = teachers.size

    teachers.sort_by!(&@order.to_sym).reverse!
    teachers.reverse! if @reverse
    @teachers = Kaminari.paginate_array(teachers).page(params[:page]).per(8)
  end

  def search
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
    render :index
  end

  private

  def set_order
    @order, @reverse = if params[:order] =~ /(.*)_reverse/
      [$1, true]
    elsif params[:order].blank?
      [:teacher_rating, false]
    else
      [params[:order], false]
    end
  end

  def verify_acceptable_order
    unless %w(teacher_rating total_lessons total_hours total_students).include?(@order.to_s)
      @order, @reverse = :teacher_rating, false
    end
  end
end
