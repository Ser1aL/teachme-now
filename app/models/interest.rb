class Interest < ActiveRecord::Base
  attr_accessible :description, :image_attachment_id
  has_one :image_attachment, as: :association
  has_many :sub_interests
  has_many :lessons
  has_many :courses

  def to_param
    "#{id}-#{I18n.t("interests.#{name}").gsub("_", '-').parameterize}"
  end
end
