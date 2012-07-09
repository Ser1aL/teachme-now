class Share < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user
  attr_accessible :share_type, :lesson_id, :user_id

  validates_inclusion_of :share_type, in: %w(study teach)

  before_validation :set_default_share_type

  def set_default_share_type
    self.share_type = self.share_type || 'teach'
  end

end
