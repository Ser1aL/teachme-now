class Quote < ActiveRecord::Base

  validates_presence_of :body
end
