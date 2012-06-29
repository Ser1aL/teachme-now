class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)

  def show
    # TODO
    # shows full description of the specific lesson
  end

  def edit
    # TODO
    # -lesson owner only
    # owner can modify his lesson here
  end

  def update
    # TODO
    # -lesson owner only
    # updates lesson
  end

  def create
    if params[:commit] == "Create Lesson"
      params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
      params[:lesson][:level].downcase!
      @lesson = Lesson.create(params[:lesson].except(:hours, :minutes))
      render :action => @lesson.new_record? ? 'new_lesson' : 'show'
    else
      @course = Course.create(params[:course].merge({owner_id: current_user.id}))
      render :action => @course.new_record? ? 'new_course' : 'show'
    end
  end

  def index
    # TODO
    # displays interest navigation panel and content block
    # provides possibility to search for lessons/courses by interests
  end
end
