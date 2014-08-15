class SitemapController < ApplicationController

  def index
    @active_record_objects = { lesson: Lesson.upcoming.enabled, course: Course.all, static_page: StaticPage.all }
    @pages = [root_url, lessons_url]
    Interest.all.each do |interest|
      @pages << interest_lessons_url(interest)
      interest.sub_interests.each do |sub_interest|
        @pages << sub_interest_lessons_url(interest, sub_interest)
      end
    end
    respond_to do |f|
      f.xml
    end
  end
end
