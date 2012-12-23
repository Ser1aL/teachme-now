class HomeController < ApplicationController

  caches_page :index

  def index
    if current_user
      redirect_to user_path(current_user)
    else
      @upcoming_lessons = Lesson.upcoming.limit(4)
    end
  end

end
