class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :birth_date, :send_emails, :sex
  attr_accessible :image_attachment_id, :user, :phone

  attr_accessor :user

  has_one :image_attachment, as: :association, dependent: :destroy

  has_many :user_registrations
  has_many :courses, foreign_key: :owner_id

  has_many :skills

  has_many :giver_ratings, foreign_key: :giver_id, class_name: 'Rating'
  has_many :ratings, foreign_key: :taker_id, class_name: 'Rating'

  has_many :leader_connections, foreign_key: :leader_id, class_name: 'UserConnection'
  has_many :follower_connections, foreign_key: :follower_id, class_name: 'UserConnection'

  has_many :leaders, through: :follower_connections, source: :leader
  has_many :followers, through: :leader_connections, source: :follower

  has_many :recommendations, foreign_key: :author_id

  has_many :lesson_subscriptions
  has_many :subscribed_lessons, through: :lesson_subscriptions, source: :lesson
  has_many :shares
  has_many :teacher_lessons, through: :shares, source: :lesson, conditions: { shares: { share_type: 'teach' } }
  has_many :student_lessons, through: :shares, source: :lesson, conditions: { shares: { share_type: 'study' } }

  has_many :comments

  validates_presence_of :first_name, :last_name
  validates :first_name, format: { without: %r(^.*[\"\\\?\!\@\#\$\%\^\:\&\?\*\(\)\<\>\`\~\|\[\]\{\}\.\,\//]+.*$) }
  validates_length_of :first_name, :last_name, minimum: 2, maximum: 22
  validates :phone, format: { with: /^[\(\)0-9\- \+\.]{7,20}$/ }, presence: true, unless: ->{ phone.nil? }

  VKONTAKTE_SEX_ASSOCIATIONS = {
    0 => 'unknown',
    1 => 'female',
    2 => 'male'
  }

  def taught_lessons
    teacher_lessons.where("lessons.start_datetime < ?", Time.now)
  end

  def upcoming_teacher_lessons
    teacher_lessons.where("lessons.start_datetime > ?", Time.now)
  end

  def trained_lessons
    student_lessons.where("lessons.start_datetime < ?", Time.now)
  end

  def upcoming_student_lessons
    student_lessons.where("lessons.start_datetime > ?", Time.now)
  end

  def upcoming_subscribed_lessons
    subscribed_lessons.where("lessons.start_datetime > ?", Time.now)
  end

  def upcoming_suitable_lessons
    Lesson.upcoming.
        joins(:teachers).
        where("sub_interest_id IN (?) AND shares.user_id != ?", self.skills.map(&:sub_interest_id), self.id).
        order(:start_datetime).
        limit(4)
  end

  def self.oauth_find_or_create(provider, auth, vkontakte_code = nil)
    begin
      UserRegistration.where(provider: provider.to_s.downcase, provider_user_id: auth.uid).first.user or raise
    rescue
      begin
        user = User.find_by_email(provider == :vkontakte ? "#{auth.uid}@vk.com" : auth.info.email)
        raise unless user
        user.create_registration(provider, auth, vkontakte_code) unless user.user_registrations.map(&:provider).include?(provider.to_s.downcase)
        user
      rescue
        user = User.create(
          email: provider == :vkontakte ? "#{auth.uid}@vk.com" : auth.info.email,
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          sex: provider == :vkontakte ? VKONTAKTE_SEX_ASSOCIATIONS[auth.extra.raw_info.sex.to_i] : auth.extra.raw_info.gender,
          password: 'fake_password',
          password_confirmation: 'fake_password',
          send_emails: true
        )
        user.create_registration provider, auth, vkontakte_code
        image_url = provider.to_s == 'vkontakte' ? auth.extra.raw_info.photo_big : auth.info.image
        Rails.logger.debug "=="
        Rails.logger.debug(image_url)
        Rails.logger.debug(auth.uid)
        Rails.logger.debug "=="
        user.image_attachment = ImageAttachment.create(image: ImageAttachment.image_from_url(image_url, auth.uid))
        user
      end
    end
  end

  def self.get_connected_users(user_id, connection_type)
    where(:id => user_id).includes(:followers => [:image_attachment, skills: :sub_interest]).last.try(connection_type.to_sym)
  end

  def self.get_watchlist_lessons(user_id)
    where(id: user_id).includes(:subscribed_lessons).last.subscribed_lessons
  end

  def full_name
    [first_name, last_name].join " "
  end

  def to_param
    "#{id}-#{full_name.parameterize}"
  end

  def facebook
    @token ||= user_registrations.where(provider: 'facebook').first.try(:hash_token)
    return nil unless @token
    @facebook ||= Koala::Facebook::API.new(@token)
  end

  def is_rated_by?(giver)
    ratings.map(&:giver_id).include? giver.id
  end

  def is_positive_rated_by?(giver)
    ratings.detect{ |rating| rating.giver_id == giver.id }.try(:rating).to_i > 0
  end

  def is_negative_rated_by?(giver)
    ratings.detect{ |rating| rating.giver_id == giver.id }.try(:rating).to_i < 0
  end

  def is_subscribed_to?(leader)
    leaders.include?(leader)
  end

  def total_rating
    ratings.sum(&:rating)
  end

  def create_registration(provider, auth, vkontakte_code = nil)
    user_registrations.create(
      provider: provider.to_s.downcase,
      provider_user_id: auth.uid,
      hash_token: auth.credentials.token,
      provider_url: auth.info.urls[provider.downcase.to_s.titleize],
      vkontakte_code: vkontakte_code
    )
  end

  def online?
    updated_at > ->{ Time.now - 10.minutes }.call
  end

  def photo_url(size = :original)
    image_attachment.try(:image).try(:url, size) || 'missing.jpg'
  end


end
