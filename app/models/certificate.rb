class Certificate < ActiveRecord::Base
  belongs_to :lesson

  validates_presence_of :lesson_id
  validates :certificate, presence: true, uniqueness: { scope: :lesson_id }
  validate :certificates_limit

  def certificates_limit
    self.lesson.capacity.to_i <= self.lesson.certificates.count
    errors.add(:certificate, 'too much') if self.lesson.capacity.to_i < self.lesson.certificates.count
  end
end
