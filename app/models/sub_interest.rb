class SubInterest < ActiveRecord::Base
  attr_accessible :association_id, :description, :interest_id
  has_one :image_attachment, as: :association
  belongs_to :interest
  has_many :lessons
end
