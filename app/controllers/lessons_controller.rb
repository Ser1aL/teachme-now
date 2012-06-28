class LessonsController < ApplicationController
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
    # TODO
    # creates lesson/course
    if params[:commit] == "Create Lesson"
      lesson_params = params[:lesson]
      date = "#{lesson_params['start_date(1i)']}-#{lesson_params['start_date(2i)']}-#{lesson_params['start_date(3i)']}"
      time = "#{lesson_params['start_date(4i)']}:#{lesson_params['start_date(5i)']}"

      Lesson.new(name: lesson_params[:name],
                 city: lesson_params[:city],
                 level: lesson_params[:level],
                 duration: lesson_params[:hours].to_i + lesson_params[:minutes].to_i,
                 description: lesson_params[:description],
                 tease_description: lesson_params[:tease_description],
                 capacity: lesson_params[:capacity],
                 place_price: lesson_params[:place_price],
                 start_date: date,
                 start_time: time).save
      render :action => "show"
    else
      @course = Course.new(params[:course])
      @course.update_attribute(:owner_id, current_user.id)
      render :action => "show"
    end
  end

  def new
    # TODO
    # gives 2 links: 'create lesson', 'create course'
  end

  def new_course
    # TODO
    # returns form for adding course
  end

  def new_lesson
    # TODO
    # returns form for adding lesson
  end

  def index
    # TODO
    # displays interest navigation panel and content block
    # provides possibility to search for lessons/courses by interests
  end
end
