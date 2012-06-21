class Skill < ActiveRecord::Base
  attr_accessible :sub_interest_id, :user_id
  belongs_to :user
  belongs_to :sub_interest
end
