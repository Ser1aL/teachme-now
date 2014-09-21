class Certificate < ActiveRecord::Base
  belongs_to :lesson

  validates :code, presence: true, uniqueness: { scope: :lesson_id }

  scope :enabled, -> { where(enabled: true) }

  def mark_disabled
    update enabled: false
  end

  def mark_enabled
    update enabled: true
  end
end
