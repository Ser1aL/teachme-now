class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index index_by_page new)
  before_filter :preload_interest_tree, only: %w(edit new_lesson index create update)
  before_filter :redirect_not_course_owner, only: %w(new_lesson create)
  before_filter :prepare_meta_data, only: %w(index)

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
    render @lesson.update_attributes(params[:lesson].except(:hours, :minutes)) ? "show" : "edit"
  end

  def create
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    if @course
      params[:lesson][:interest_id] = @course.interest_id
      params[:lesson][:sub_interest_id] = @course.sub_interest_id
    end
    @lesson = current_user.teacher_lessons.create(params[:lesson].except(:hours, :minutes))
    if @lesson.new_record?
      render :action => 'new_lesson'
    else
      redirect_to lesson_path(@lesson)
    end
  end

  def index
    @selected_interest = @interests.select{ |interest| interest.to_param == params[:interest_id] }.first || @interests.first
    @lessons = begin
      if params[:sub_interest_id]
        Lesson.upcoming.where(sub_interest_id: params[:sub_interest_id]).by_page(params[:page])
      elsif params[:interest_id]
        Lesson.upcoming.where(interest_id: params[:interest_id]).by_page(params[:page])
      else
        Lesson.upcoming.by_page(params[:page])
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

  def prepare_meta_data
    if params[:sub_interest_id]
      @pre_word = I18n.t("sub_interests.#{SubInterest.find(params[:sub_interest_id]).name}")
    elsif params[:interest_id]
      @pre_word = I18n.t("interests.#{@interests.find(params[:interest_id]).name}")
    else
      @pre_word = I18n.t('meta.lessons.default_pre_word')
    end

  end
end
