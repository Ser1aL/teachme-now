class Course < ActiveRecord::Base
  # attr_accessible :city, :description, :name, :owner_id, :times_per_week, :interest_id, :sub_interest_id
  has_many :lessons, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user, foreign_key: :owner_id
  belongs_to :interest
  belongs_to :sub_interest

  acts_as_taggable

  validates_presence_of :city, :description
  validates_presence_of :interest_id, :sub_interest_id, :owner_id, :times_per_week
  validates :description, length: { minimum: 140, maximum: 10000 }
  validates_numericality_of :times_per_week, greater_than: 0
  validates :name, presence: true, length: {maximum: 140}

  # default_scope ->{ puts 'WARNING: using default scope'; where(enabled: true) }

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def buyable_for?(params_user)
    params_user != user && lessons.present? && !passed? && available? && !is_already_applied?(user)
  end

  def is_owner?(params_user)
    user == params_user
  end

  def is_already_applied?(params_user)
    return false if lessons.blank?
    lessons.upcoming.each do |lesson|
      return false if lesson.user_already_applied?(params_user)
    end
    true
  end

  def available?
    return false if lessons.blank?
    lessons.upcoming.each do |lesson|
      return true if lesson.available?
    end
    false
  end

  def passed?
    return false if lessons.blank?
    lessons.upcoming.each do |lesson|
      return false unless lesson.passed?
    end
    true
  end

  def update_lessons_interest(interest_id, sub_interest_id)
    lessons.each do |lesson|
      lesson.update_column :interest_id, interest_id
      lesson.update_column :sub_interest_id, sub_interest_id
    end
  end

  class << self

    def by_page(page, per_page = nil)
      per_page ||= APP_CONFIG['courses_per_page']
      page(page).per(per_page)
    end

  end

end
