class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)

  def show
    @lesson = Lesson.find_by_id(params[:id])
  end

  def edit
    # TODO
    # -lesson owner only
    # owner can modify his lesson here
    # newsletter to subscribers about changing the lesson / course
  end

  def update
    # TODO
    # -lesson owner only
    # updates lesson
  end

  def create
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    @lesson = Lesson.create(params[:lesson].except(:hours, :minutes))
    render :action => @lesson.new_record? ? 'new_lesson' : 'show'
  end

  def index
    # TODO
    # displays interest navigation panel and content block
    # provides possibility to search for lessons/courses by interests
  end
end
