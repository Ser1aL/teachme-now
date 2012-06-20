class Recommendation < ActiveRecord::Base
  attr_accessible :author_id, :lesson_id, :text

  belongs_to :user, foreign_key: :author_id
  belongs_to :lesson
end
