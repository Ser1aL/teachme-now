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
  end

  def new
    # TODO
    # with empty params gives 2 links: 'create lesson', 'create course'
    # returns new form for lesson/course if selected
  end

  def index
    # TODO
    # displays interest navigation panel and content block
    # provides possibility to search for lessons/courses by interests
  end
end
