class Lesson < ActiveRecord::Base
  attr_accessible :capacity, :city, :course_id, :description, :duration
  attr_accessible :interest_id, :level, :name, :owner_id, :place_price
  attr_accessible :places_taken, :start_date, :start_time, :sub_interest_id, :tease_description, :hours, :minutes

  belongs_to :interest
  belongs_to :sub_interest
  belongs_to :course
  has_many :shares

  has_many :students, through: :shares, source: :user, conditions: { shares: { share_type: 'study' } }
  has_many :teachers, through: :shares, source: :user, conditions: { shares: { share_type: 'teach' } }

  has_many :lesson_subscriptions
  has_many :subscribed_users, through: :lesson_subscriptions, source: :user

  has_many :recommendations

  validates_inclusion_of :level, in: %w(beginner low medium high expert)

  SUPPORTED_CITIES = %w(odessa kiev)
  HOURS = [["1 hour", "60"], ["2 hours", "120"], ["3 hours", "180"], ["4 hours", "240"], ["5 hours", "300"],
           ["6 hours", "360"], ["7 hours", "420"], ["8 hours", "480"], ["9 hours", "540"], ["10 hours", "600"],
           ["11 hours", "660"], ["12 hours", "720"]]
  MINUTES = [["15 minutes", "15"], ["30 minutes", "30"], ["45 minutes", "45"]]

  def hours
  end

  def minutes
  end

end
