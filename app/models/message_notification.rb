class MessageNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  # attr_accessible :user, :is_read
end
