class CoursesController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)

  def show
    @course = Course.find(params[:id])
  end

  def edit
    # TODO
    # newsletter to subscribers about changing the lesson / course
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course.update_attributes(params[:course])
    render :action => "show"
  end

  def create
    @course = Course.create(params[:course].merge({owner_id: current_user.id}))
    if @course.new_record?
      render :action => 'new'
    else
      redirect_to course_path(@course)
    end
  end

  def index
  end
end