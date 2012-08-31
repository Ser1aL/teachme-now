class Course < ActiveRecord::Base
  attr_accessible :city, :description, :name, :owner_id, :tease_description, :times_per_week, :interest_id, :sub_interest_id
  has_many :lessons
  belongs_to :user, foreign_key: :owner_id
  belongs_to :interest
  belongs_to :sub_interest

  validates_presence_of :city, :description, :tease_description
  validates_presence_of :interest_id, :sub_interest_id, :owner_id, :times_per_week

  validates_numericality_of :times_per_week, greater_than: 0
  validates :name, presence: true, uniqueness: true, length: {maximum: 140}
end
