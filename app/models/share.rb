class Share < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user
  attr_accessible :share_type
end
