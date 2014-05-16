class Subscription < ActiveRecord::Base
  # attr_accessible :email

  validates_format_of :email, with: /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
end
