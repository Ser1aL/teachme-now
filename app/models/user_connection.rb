class UserConnection < ActiveRecord::Base

  belongs_to :user, foreign_key: :leader_id
  belongs_to :user, foreign_key: :follower_id
  belongs_to :leader, foreign_key: :leader_id, class_name: 'User'
  belongs_to :follower, foreign_key: :follower_id, class_name: 'User'
end
