class Rating < ActiveRecord::Base
  # attr_accessible :rating, :giver_id, :taker_id

  belongs_to :user, foreign_key: :giver_id
  belongs_to :user, foreign_key: :taker_id
end
