class LessonSubscription < ActiveRecord::Base
  attr_accessible :lesson_id, :user_id

  belongs_to :lesson
  belongs_to :user
end
