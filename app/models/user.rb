class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :birth_date, :send_emails, :sex
  attr_accessible :image_attachment_id

  has_one :image_attachment, as: :association
  has_many :user_registrations
  has_many :courses

  has_many :skills

  has_many :teacher_ratings, foreign_key: :teacher_id, class_name: 'Rating'
  has_many :student_ratings, foreign_key: :student_id, class_name: 'Rating'

  has_many :leader_connections, foreign_key: :leader_id, class_name: 'UserConnection'
  has_many :follower_connections, foreign_key: :follower_id, class_name: 'UserConnection'
  has_many :leaders, through: :follower_connections, source: :user
  has_many :followers, through: :leader_connections, source: :user

  has_many :recommendations, foreign_key: :author_id

  has_many :lesson_subscriptions
  has_many :subscribed_lessons, through: :lesson_subscriptions, source: :lesson
  has_many :shares
  has_many :teacher_lessons, through: :shares, source: :lesson, conditions: { shares: { share_type: 'teach' } }
  has_many :student_lessons, through: :shares, source: :lesson, conditions: { shares: { share_type: 'study' } }

  VKONTAKTE_SEX_ASSOCIATIONS = {
    0 => 'unknown',
    1 => 'female',
    2 => 'male'
  }

  def taught_lessons
    teacher_lessons.where("lessons.updated_at < ?", Time.now)
  end

  def upcoming_teacher_lessons
    teacher_lessons.where("lessons.updated_at > ?", Time.now)
  end

  def trained_lessons
    student_lessons.where("lessons.updated_at < ?", Time.now)
  end

  def upcoming_student_lessons
    student_lessons.where("lessons.updated_at > ?", Time.now)
  end

  def self.oauth_find_or_create(provider, auth)
    begin
      UserRegistration.where(provider: provider.to_s.downcase, provider_user_id: auth.uid).first.user
    rescue
      begin
        User.find_by_email(provider == :vkontakte ? "#{auth.uid}@vk.com" : auth.info.email) or raise
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
        user.user_registrations.create(
          provider: provider.to_s.downcase,
          provider_user_id: auth.uid,
          hash_token: auth.credentials.token,
          provider_url: auth.info.urls[provider.downcase.to_s.titleize]
        )
        user.image_attachment = ImageAttachment.create(image: ImageAttachment.image_from_url(auth.info.image, auth.uid))
        user
      end
    end
  end

  def full_name
    [first_name, last_name].join " "
  end

end
