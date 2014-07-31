class Interest < ActiveRecord::Base
  has_one :image_attachment, as: :image_association
  has_many :sub_interests
  has_many :lessons
  has_many :courses

  def to_param
    "#{id}-#{translation.to_s.gsub("_", '-').parameterize}"
  end
end
