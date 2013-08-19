class ClassesController < ApplicationController

  def index
    @lessons_by_groups = {}

    Interest.all.each do |interest|
      @lessons_by_groups.merge! interest => Lesson.upcoming.where(interest_id: interest.id).limit(4)
    end
  end

  def search
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
    render :index
  end
end
