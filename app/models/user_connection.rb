class UserConnection < ActiveRecord::Base
  attr_accessible :follower_id, :leader_id

  belongs_to :user, foreign_key: :leader_id
  belongs_to :user, foreign_key: :follower_id
end
