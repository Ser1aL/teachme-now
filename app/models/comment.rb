class Comment < ActiveRecord::Base
  attr_accessible :body, :user_id, :commentable_type, :commentable_id

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :message_notifications

  validates :body, presence: true, length: { maximum: 2020 }
  validates :commentable_type, inclusion: %w(Course Lesson)
  validates :user_id, presence: true

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
        :guest
      end
    end
  end

  def create_message_notifications!(except = nil)
    users = []

    if self.commentable.is_a?(Course)
      users += self.commentable.comments.map(&:user)
      self.commentable.lessons.each do |lesson|
        users += lesson.associated_users
        users += lesson.comments.map(&:user)
      end
    elsif self.commentable.is_a?(Lesson)
      users += self.commentable.associated_users
      users += self.commentable.comments.map(&:user)
    end

    users.uniq.each do |user|
      self.message_notifications.create(user: user) unless except == user
    end

  end
end
