class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :lesson
  has_many :message_notifications

  validates :body, presence: true, length: { maximum: 2020 }
  validates :user_id, presence: true

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

  def create_message_notifications!(except = nil)
    users = []
    users += self.lesson.associated_users
    users += self.lesson.comments.map(&:user)

    users.uniq.each do |user|
      self.message_notifications.create(user: user) unless except == user
    end

  end
end
