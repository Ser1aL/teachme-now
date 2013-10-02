class Lesson < ActiveRecord::Base

  acts_as_taggable

  attr_accessible :capacity, :city, :course_id, :description_bottom, :description_top, :duration, :address_line
  attr_accessible :interest_id, :level, :name, :owner_id, :place_price
  attr_accessible :places_taken, :start_datetime, :sub_interest_id
  attr_accessible :file_attachments, :image_attachments, :enabled

  PRO_DISCOUNT_FOR_STUDENT = 0.03
  PRO_DISCOUNT_FOR_TEACHER = 0.03
  TRANSACTION_PERCENT = 0.01
  MERCHANT_ID = 'i0608833938'
  MERCHANT_SIGNATURE = 'Te8RPBUlWix0nUMFhwnSttuAlQs1bLv0'
  LIQPAY_SERVER_RESPONSE_URL = 'http://teach-me.com.ua'
  LIQPAY_RESPONSE_URL = 'http://teach-me.com.ua/passes'

  # pro prices { months => per_month }
  PRO_PRICE_RELATIONS = { '1' => 75, '3' => 65, '6' => 55, '12' => 50 }

  belongs_to :interest
  belongs_to :sub_interest
  belongs_to :course
  has_many :shares
  has_many :students, through: :shares, source: :user, conditions: { shares: { share_type: 'study' } }
  has_many :teachers, through: :shares, source: :user, conditions: { shares: { share_type: 'teach' } }
  has_many :associated_users, through: :shares, source: :user
  has_many :lesson_subscriptions
  has_many :subscribed_users, through: :lesson_subscriptions, source: :user
  has_many :recommendations
  has_many :comments, as: :commentable
  has_many :image_attachments, as: :association, dependent: :destroy
  has_many :file_attachments, as: :association, dependent: :destroy

  default_scope { puts 'WARNING: using default scope'; order(:start_datetime) }
  scope :enabled, -> { where(enabled: true) }

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
      upcoming.where('start_datetime BETWEEN ? AND ?', Date.today.beginning_of_day, (Date.today + day_difference).beginning_of_day)
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
      with_exclusive_scope { upcoming.order(:places_taken) }
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
    teacher != user && !user_already_applied?(user) && available? && !passed?
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
    # TODO send email
    update_attributes(enabled: true)
  end

  def markup_lesson_price
    old_adjusted_price = self.adjusted_price
    self.adjusted_price = self.place_price + (self.place_price * ( PRO_DISCOUNT_FOR_STUDENT + PRO_DISCOUNT_FOR_TEACHER + TRANSACTION_PERCENT )).ceil
    self.enabled = false if old_adjusted_price.to_i != self.adjusted_price.to_i
    true
  end

  def pro_discount
    (adjusted_price * PRO_DISCOUNT_FOR_STUDENT).round
  end

  def discount_adjusted_price
    adjusted_price - pro_discount
  end

  def build_tokens(buyer_id)
    return if @tokens_hash.present?
    @tokens_hash = {}
    @tokens_hash[:full] = build_token(adjusted_price, 0, buyer_id)
    @tokens_hash[:discount] = build_token(discount_adjusted_price, 0, buyer_id)
    @tokens_hash[:with_1_month_pro] = build_token(discount_adjusted_price, 1, buyer_id)
    @tokens_hash[:with_3_month_pro] = build_token(discount_adjusted_price, 3, buyer_id)
    @tokens_hash[:with_6_month_pro] = build_token(discount_adjusted_price, 6, buyer_id)
    @tokens_hash[:with_12_month_pro] = build_token(discount_adjusted_price, 12, buyer_id)
    @tokens_hash
  end

  def build_token(price, pro_months, buyer_id)
    final_price = price
    order_id = "ORDER_ID_#{self.id}_#{Time.now.to_f.to_s.gsub(/\./, '').last(4)}"
    description = '1 place for lesson'
    if pro_months > 0
      final_price += pro_months * PRO_PRICE_RELATIONS[pro_months.to_s]
      description += " + #{pro_months} months pro account" if pro_months > 0
    end

    xml = "<request>
        <version>1.2</version>
        <result_url>#{LIQPAY_SERVER_RESPONSE_URL}</result_url>
        <server_url>#{LIQPAY_RESPONSE_URL}</server_url>
        <merchant_id>#{MERCHANT_ID}</merchant_id>
        <order_id>#{order_id}</order_id>
        <amount>#{final_price.to_f}</amount>
        <currency>UAH</currency>
        <description>#{description}</description>
        <default_phone>+380966048525</default_phone>
        <pay_way>card</pay_way>
        <goods_id>#{self.id}_#{buyer_id}</goods_id>
      </request>".squish

    payload_token = Base64.encode64(xml)
    signature = Base64.encode64(Digest::SHA1.digest("#{MERCHANT_SIGNATURE}#{xml}#{MERCHANT_SIGNATURE}"))
    { payload_token: payload_token.strip, signature: signature.strip }
  end

end
