class Certificate < ActiveRecord::Base
  belongs_to :lesson

  validates :code, presence: true, uniqueness: { scope: :lesson_id }
end
