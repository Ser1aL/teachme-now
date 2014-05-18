class Recommendation < ActiveRecord::Base

  belongs_to :user, foreign_key: :author_id
  belongs_to :lesson
end
