class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)
  before_filter :preload_interest_tree, only: %w(edit new_lesson index create update)

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
    @lesson = current_user.teacher_lessons.create(params[:lesson].except(:hours, :minutes))
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

  private
    def preload_interest_tree
      @interests = Interest.includes(:sub_interests)
    end
end
