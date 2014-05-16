class Lesson < ActiveRecord::Base

  acts_as_taggable

  # attr_accessible :capacity, :city, :course_id, :description_bottom, :description_top, :duration, :address_line
  # attr_accessible :interest_id, :level, :name, :owner_id, :place_price
  # attr_accessible :places_taken, :start_datetime, :sub_interest_id, :adjustment_used
  # attr_accessible :file_attachments, :image_attachments, :enabled

  PRO_DISCOUNT_FOR_STUDENT = 0.04
  PRO_DISCOUNT_FOR_TEACHER = 0.04
  TRANSACTION_PERCENT = 0.02
  FULL_PERCENT = PRO_DISCOUNT_FOR_STUDENT + PRO_DISCOUNT_FOR_TEACHER + TRANSACTION_PERCENT
  HUMAN_FULL_PERCENT = (FULL_PERCENT * 100).to_i
  MERCHANT_ID = 'i0608833938'
  MERCHANT_SIGNATURE = 'Te8RPBUlWix0nUMFhwnSttuAlQs1bLv0'
  #ROOT_URL = Rails.env.development? ? 'http://omniauth-tester.loc' : 'http://teach-me.com.ua'
  ROOT_URL = 'http://teach-me.com.ua'
  LIQPAY_SERVER_RESPONSE_URL = "#{ROOT_URL}/passes"
  LIQPAY_PURE_PRO_RESPONSE_URL = "#{ROOT_URL}/create_pro"
  LIQPAY_RESPONSE_URL = 'http://teach-me.com.ua'

  # pro prices { months => per_month }
  PRO_PRICE_RELATIONS = { '1' => 75, '3' => 65, '6' => 55, '12' => 50 }

  belongs_to :interest
  belongs_to :sub_interest
  belongs_to :course
  has_many :shares
  has_many :students, ->{ where(shares: { share_type: 'study'}) }, through: :shares, source: :user
  has_many :teachers, ->{ where(shares: { share_type: 'teach'}) }, through: :shares, source: :user
  has_many :associated_users, through: :shares, source: :user
  has_many :lesson_subscriptions
  has_many :subscribed_users, through: :lesson_subscriptions, source: :user
  has_many :recommendations
  has_many :comments, as: :commentable
  has_many :image_attachments, as: :image_association, dependent: :destroy
  has_many :file_attachments, as: :file_association, dependent: :destroy

  default_scope { puts 'WARNING: using default scope'; order(:start_datetime) }
  scope :enabled, -> { where(enabled: true) }
  scope :within_creation_time_range, ->(start_time, end_time) { where('created_at between ? and ?', start_time, end_time) }
  scope :within_start_time_range, ->(start_time, end_time) { where('start_datetime between ? and ?', start_time, end_time) }

  validates_presence_of :city, :address_line
  validates_presence_of :start_datetime, :interest_id, :sub_interest_id
  validates :capacity, presence: true
  validates :place_price, presence: true
  validates :name, presence: true, length: { maximum: 140 }
  validates :level, inclusion: { in: %w(beginner low medium high expert) }
  validates :duration, inclusion: { in: 15..765 }
  validates :address_line, length: { minimum: 7, maximum: 140 }
  validates_numericality_of :capacity, :place_price, greater_than: 0
  validate :date_greater_than_now
  validates :city, inclusion: { in: APP_CONFIG["supported_cities"] }
  validates :description_top, presence: true, length: { minimum: 140, maximum: 10000 }, if: -> { self.description_bottom.blank? }
  validates :description_bottom, presence: true, length: { minimum: 140, maximum: 10000 }, if: -> { self.description_top.blank? }

  before_save :markup_lesson_price
  before_save :format_description_fields

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
      day_difference = 120
      upcoming.where('start_datetime BETWEEN ? AND ?', Date.today.beginning_of_day, (Date.today + day_difference).beginning_of_day)
    end

    def by_page(page, per_page = nil)
      per_page ||= APP_CONFIG['lessons_per_page']
      page(page).per(per_page)
    end

    def by_lowest_price
      unscoped.order(:place_price)
    end

    def most_rated_lesson
      user_with_highest_rating = User.joins(:ratings).group('users.id').joins(:teacher_lessons).order('sum(ratings.rating) desc').first
      user_with_highest_rating.upcoming_teacher_lessons.enabled.sample(1).first if user_with_highest_rating.present?
    end

    # Exclusive scope
    def by_popularity
      unscoped.order(:places_taken)
    end

    def slow_search(query = nil)
      return scoped if query.blank?
      where('name like ? OR description_top like ? OR description_bottom like ?', "%#{query}%", "%#{query}%", "%#{query}%")
    end
  end

  def available?
    capacity > places_taken
  end

  def buyable_for?(user)
    teacher != user && !user_already_applied?(user) && available? && !passed? && enabled?
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

  def image_urls(size = :original)
    image_attachments.map { |attachment| attachment.try(:image).try(:url, size) || 'missing.jpg' }
  end

  def free_places_count
    capacity - places_taken
  end

  def mark_enabled
    update_attributes(enabled: true)
  end

  def mark_disabled
    update_attributes(enabled: false)
  end

  def format_description_fields
    self.description_top.gsub!('&nbsp;', ' ')
    self.description_bottom.gsub!('&nbsp;', ' ')
  end

  def markup_lesson_price
    old_adjusted_price, old_user_adjustment = self.adjusted_price, self.adjustment_used

    if self.adjustment_used?
      self.adjusted_price = self.place_price + (self.place_price * FULL_PERCENT).ceil
    else
      self.adjusted_price = self.place_price
    end

    self.enabled = false if old_adjusted_price.to_i != self.adjusted_price.to_i || old_user_adjustment != self.adjustment_used
    true
  end

  def pro_discount
    (adjusted_price.to_i * PRO_DISCOUNT_FOR_STUDENT).round
  end

  def discount_adjusted_price
    adjusted_price.to_i - pro_discount.to_i
  end

end
