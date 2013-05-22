class HomeController < ApplicationController

  def index
    @nearest_lessons = Lesson.nearest.limit(4).includes(:teachers => :image_attachment).includes(:interest, :sub_interest)
    @lowest_price_lesson = Lesson.by_lowest_price.first
    @most_rated_lesson = Lesson.most_rated_lesson
    @most_popular_lesson = Lesson.by_popularity.last
  end

end
