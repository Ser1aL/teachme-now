class Comment < ActiveRecord::Base
  attr_accessible :body, :user_id

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { maximum: 2020 }

  def commenter_type
    @commenter_type ||= begin
      if commentable.is_a?(Lesson)
        if commentable.teachers.include?(user)
          :teacher
        elsif commentable.user_already_applied?(user)
          :student
        else
          :guest
        end
      else
        @commenter_type = :guest
      end
    end
  end
end
