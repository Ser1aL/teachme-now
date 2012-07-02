class Interest < ActiveRecord::Base
  attr_accessible :description, :image_attachment_id
  has_one :image_attachment, as: :association
  has_many :sub_interests
  has_many :lessons
  has_many :courses
end
