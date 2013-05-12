class HomeController < ApplicationController

  def index
    @upcoming_lessons = Lesson.upcoming.limit(4)
  end

end
