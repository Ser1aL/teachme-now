class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)

  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    # TODO
    # newsletter to subscribers about changing the lesson / course
    @lesson = Lesson.find(params[:id])
    @hours = @lesson.duration/60
    @minutes = @lesson.duration%60
  end

  def update
    @lesson = Lesson.find(params[:id])
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    @lesson.update_attributes(params[:lesson].except(:hours, :minutes))
    render :action => "show"
  end

  def create
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    @lesson = current_user.teacher_lessons.create(params[:lesson].except(:hours, :minutes))
    render :action => @lesson.new_record? ? 'new_lesson' : 'show'
  end

  def index
    # TODO
    # displays interest navigation panel and content block
    # provides possibility to search for lessons/courses by interests
  end
end
