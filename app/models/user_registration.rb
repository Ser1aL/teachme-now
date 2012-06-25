class UserRegistration < ActiveRecord::Base
  attr_accessible :hash_token, :provider, :provider_user_id, :provider_url
  belongs_to :user

  validates_inclusion_of :provider, in: %w(facebook vkontakte linkedin twitter gitub)
end
