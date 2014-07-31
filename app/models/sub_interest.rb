class SubInterest < ActiveRecord::Base
  has_one :image_attachment, as: :image_association
  belongs_to :interest
  has_many :lessons
  has_many :skills

  validates :name, presence: true, uniqueness: true
  validates :interest_id, presence: true

  def to_param
    "#{id}-#{translation.to_s.gsub("_", '-').parameterize}"
  end

  def self.by_page(page, per_page = nil)
    per_page ||= APP_CONFIG['lessons_per_page']
    page(page).per(per_page)
  end
end
