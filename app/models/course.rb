class Course < ActiveRecord::Base
  attr_accessible :city, :description, :name, :owner_id, :tease_descriptions, :times_per_week, :interest_id, :sub_interest_id
  has_many :lessons
  belongs_to :users, foreign_key: :owner_id
  belongs_to :interest
  belongs_to :sub_interest
end
