class Rating < ActiveRecord::Base
  attr_accessible :rating, :student_id, :teacher_id

  belongs_to :user, foreign_key: :student_id
  belongs_to :user, foreign_key: :teacher_id
end
