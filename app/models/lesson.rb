class Lesson < ActiveRecord::Base
  attr_accessible :capacity, :city, :course_id, :description, :duration, :address_line
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
  has_many :comments

  default_scope { order(:start_datetime) }

  validates_presence_of :city, :description, :tease_description, :address_line
  validates_presence_of :start_datetime, :interest_id, :sub_interest_id
  validates :capacity, presence: true
  validates :place_price, presence: true
  validates :name, presence: true, length: { maximum: 140 }, format: { without: %r(^.*[\"\?\!\@\#\$\%\^\*\`\~\|/]+.*$) }
  validates :level, inclusion: { in: %w(beginner low medium high expert) }
  validates :duration, inclusion: { in: 15..765 }
  validates :address_line, length: { minimum: 7, maximum: 140 }
  validates_numericality_of :capacity, :place_price, greater_than: 0
  validate :date_greater_than_now
  validates :city, inclusion: { in: APP_CONFIG["supported_cities"] }

  private

  def date_greater_than_now
    # TODO: change message to I18n and provide output to the form
    errors.add(:start_datetime, "is invalid.") if start_datetime.blank? || start_datetime < DateTime.now
  end

  public

  def hours
  end

  def minutes
  end

  class << self

    def upcoming
      where('lessons.start_datetime > ?', Time.now)
    end

    def nearest
      day_difference = 14
      where('start_datetime BETWEEN ? AND ?', Date.today.beginning_of_day, (Date.today + day_difference).beginning_of_day)
    end

    def by_page(page)
      page(page).per(APP_CONFIG["lessons_per_page"])
    end

    def by_lowest_price
      with_exclusive_scope { upcoming.order(:place_price) }
    end

    def most_rated_lesson
      user_with_highest_rating = User.joins(:ratings).group('users.id').joins(:teacher_lessons).order('sum(ratings.rating) desc').first
      user_with_highest_rating.upcoming_teacher_lessons.sample(1).first if user_with_highest_rating.present?
    end

    # Exclusive scope
    def by_popularity
      with_exclusive_scope { order(:places_taken) }
    end
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
    "#{id}-#{name.parameterize}"
  end

  def passed?
    ->{ Time.now }.call > start_datetime
  end

  def teacher
    teachers.first
  end

end
