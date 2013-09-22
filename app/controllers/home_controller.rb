class HomeController < ApplicationController

  def index
    @nearest_lessons = Lesson.enabled.nearest.limit(4).includes(:teachers => :image_attachment).includes(:interest, :sub_interest)
    @lowest_price_lesson = Lesson.enabled.by_lowest_price.first
    @most_popular_lesson = Lesson.enabled.by_popularity.last
    @most_rated_lesson = Lesson.enabled.most_rated_lesson
    @random_users = User.order('RAND()').includes(:image_attachment).limit(15) || []
    @random_quote = Quote.order('RAND()').first
  end

end
