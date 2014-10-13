class HomeController < ApplicationController

  def index
    @interests = @interests.first(5)
    @nearest_lessons = Lesson.index_page_scope.nearest.limit(9).includes(teachers: :image_attachment).includes(:interest, :sub_interest)
    @random_users = User.order('RAND()').includes(:image_attachment).limit(15) || []
    @lesson_counts = Lesson.index_page_scope.inject({}) do |counts, lesson|
      counts[lesson.sub_interest_id] ||= 0
      counts[lesson.sub_interest_id] +=1
      counts
    end
  end

end
