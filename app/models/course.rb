class Course < ActiveRecord::Base
  attr_accessible :city, :description, :name, :owner_id, :tease_descriptions, :times_per_week
  has_many :lessons
  belongs_to :users, foreign_key: :owner_id
end
