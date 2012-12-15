class Comment < ActiveRecord::Base
  attr_accessible :body, :lesson_id, :user_id
  belongs_to :lesson
  belongs_to :user

  validates :body, presence: true, length: { minimum: 3, maximum: 1020 }

  def commenter_type
    @commenter_type ||= begin
      if lesson.teachers.include?(user)
        :teacher
      elsif lesson.user_already_applied?(user)
        :student
      else
        :guest
      end
    end
  end
end
