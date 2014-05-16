class SubInterest < ActiveRecord::Base
  # attr_accessible :association_id, :description, :interest_id
  has_one :image_attachment, as: :image_association
  belongs_to :interest
  has_many :lessons
  has_many :skills

  def to_param
    "#{id}-#{I18n.t("sub_interests.#{name}").gsub("_", '-').parameterize}"
  end
end
