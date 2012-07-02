class CoursesController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)

  def show
    @course = Course.find_by_id(params[:id])
  end

  def edit
    # TODO
    # -course owner only
    # owner can modify his course here
    # newsletter to subscribers about changing the lesson / course
  end

  def update
    # TODO
    # -course owner only
    # updates course
  end

  def create
    @course = Course.create(params[:course].merge({owner_id: current_user.id}))
    render :action => @course.new_record? ? 'new_course' : 'show'
  end

  def index
  end
end