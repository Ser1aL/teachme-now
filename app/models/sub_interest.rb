class SubInterest < ActiveRecord::Base
  has_one :image_attachment, as: :image_association
  belongs_to :interest
  has_many :lessons
  has_many :skills

  def to_param
    "#{id}-#{I18n.t("sub_interests.#{name}").gsub("_", '-').parameterize}"
  end
end
