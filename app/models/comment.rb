class Comment < ActiveRecord::Base
  attr_accessible :body, :lesson_id, :user_id
  belongs_to :lesson
  belongs_to :user

  validates :body, presence: true, length: { minimum: 3, maximum: 1020 }
end
