class ClassesController < ApplicationController

  def index
    @lessons_by_groups = []

    @interests.includes(:lessons).each do |interest|
      @lessons_by_groups << [ interest, interest.lessons.upcoming.limit(4) ]
    end
  end

  def search
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
    render :index
  end
end
