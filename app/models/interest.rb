class Interest < ActiveRecord::Base
  has_one :image_attachment, as: :image_association
  has_many :sub_interests
  has_many :lessons
  has_many :courses

  validates :name, presence: true, uniqueness: true

  def to_param
    "#{id}-#{I18n.t("interests.#{name}").gsub("_", '-').parameterize}"
  end

  def self.by_page(page, per_page = nil)
    per_page ||= APP_CONFIG['lessons_per_page']
    page(page).per(per_page)
  end
end
