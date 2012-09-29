class Lesson < ActiveRecord::Base
  attr_accessible :capacity, :city, :course_id, :description, :duration
  attr_accessible :interest_id, :level, :name, :owner_id, :place_price
  attr_accessible :places_taken, :start_datetime, :sub_interest_id, :tease_description

  belongs_to :interest
  belongs_to :sub_interest
  belongs_to :course
  has_many :shares

  has_many :students, through: :shares, source: :user, conditions: { shares: { share_type: 'study' } }
  has_many :teachers, through: :shares, source: :user, conditions: { shares: { share_type: 'teach' } }

  has_many :lesson_subscriptions
  has_many :subscribed_users, through: :lesson_subscriptions, source: :user

  has_many :recommendations

  validates_presence_of :city, :description, :tease_description
  validates_presence_of :start_datetime, :interest_id, :sub_interest_id

  validates :capacity, presence: true, numericality: true
  validates :place_price, presence: true, numericality: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 140 }, format: { without: %r(^.*[\"\?\!\@\#\$\%\^\*\`\~\|/]+.*$) }
  validates :level, inclusion: { in: %w(beginner low medium high expert) }
  validates :duration, inclusion: { in: 15..765 }

  SUPPORTED_CITIES = %w(odessa)
  LESSONS_PER_PAGE = 3

  def hours
  end

  def minutes
  end

  def self.upcoming
    where("lessons.start_datetime > ?", Time.now)
  end

  def self.by_page(page)
    page(page).per(LESSONS_PER_PAGE)
  end

  def available?
    capacity > places_taken
  end

  def create_enrollment(user)
    Share.create(user: user, lesson: self, share_type: 'study')
    increment!(:places_taken)
  end

  def create_subscription(user)
    LessonSubscription.create(user: user, lesson: self)
  end

  def user_already_applied?(user)
    students.include?(user)
  end

  def already_in_watchlist?(user)
    LessonSubscription.find_by_user_id_and_lesson_id(user, self).present?
  end

  def to_param
    "#{id}-#{interest.name}"
  end

end
