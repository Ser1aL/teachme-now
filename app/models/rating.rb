class Rating < ActiveRecord::Base

  belongs_to :user, foreign_key: :giver_id
  belongs_to :user, foreign_key: :taker_id
end
