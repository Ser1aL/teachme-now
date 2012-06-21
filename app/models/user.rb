class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :birth_date, :send_emails

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

  def taught_lessons
    # TODO
    # returns teacher_lessons where lessons.updated_at < NOW()
  end

  def upcoming_teacher_lessons
    # TODO
    # returns teacher_lessons where lessons.updated_at > NOW()
  end

  def trained_lessons
    # TODO
    # returns student_lessons where lessons.updated_at < NOW()
  end

  def upcoming_student_lessons
    # TODO
    # returns student_lessons where lessons.updated_at > NOW()
  end

end
