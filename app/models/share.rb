class Share < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user
  attr_accessible :share_type

  validates_inclusion_of :share_type, in: %w(study teach)
end
