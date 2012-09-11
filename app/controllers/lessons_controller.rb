class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index index_by_page)
  before_filter :preload_interest_tree, only: %w(edit new_lesson index create update)
  before_filter :redirect_not_course_owner, only: %w(new_lesson create)

  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    if @lesson.update_attributes(params[:lesson].except(:hours, :minutes))
      render :action => "show"
    else
      redirect_to :back, flash: { errors: current_user.errors }
    end
  end

  def create
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    if @course
      params[:lesson][:interest_id] = @course.interest_id
      params[:lesson][:sub_interest_id] = @course.sub_interest_id
    end
    @lesson = current_user.teacher_lessons.create(params[:lesson].except(:hours, :minutes))
    logger.debug params[:lesson]
    logger.debug @lesson.errors.full_messages
    if @lesson.new_record?
      render :action => 'new_lesson'
    else
      redirect_to lesson_path(@lesson)
    end
  end

  def index
    @page = params[:page]
    @lessons = begin
      if params[:sub_interest_id]
        Lesson.upcoming.where(sub_interest_id: params[:sub_interest_id]).by_page(@page)
      elsif params[:interest_id]
        Lesson.upcoming.where(interest_id: params[:interest_id]).by_page(@page)
      else
        Lesson.upcoming.by_page(@page)
      end
    end
  end

  def index_by_page
    @lessons = begin
      if params[:interest_id].present?
        if params[:sub_interest_id].present?
          Lesson.upcoming.where(interest_id: params[:interest_id], sub_interest_id: params[:sub_interest_id]).by_page(params[:page])
        else
          Lesson.upcoming.where(interest_id: params[:interest_id]).by_page(params[:page])
        end
      else
        Lesson.upcoming.by_page(params[:page])
      end
    end
    render @lessons, layout: false
  end

  private

  def preload_interest_tree
    @interests = Interest.includes(:sub_interests)
  end

  def redirect_not_course_owner
    @course = Course.find(params[:course_id]) if params[:course_id]
    @course = Course.find(params[:lesson][:course_id]) unless params[:lesson].try(:[], :course_id).blank?
    redirect_to root_path, notice: "You are not owner of this course" if @course && @course.user != current_user
  end
end
