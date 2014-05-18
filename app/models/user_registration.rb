class UserRegistration < ActiveRecord::Base
  belongs_to :user

  validates_inclusion_of :provider, in: %w(facebook vkontakte linkedin twitter gitub)
end
