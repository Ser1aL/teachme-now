class UserRegistration < ActiveRecord::Base
  attr_accessible :hash_token, :provider
  belongs_to :user
end
