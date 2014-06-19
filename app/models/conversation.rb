class Conversation < ActiveRecord::Base

  has_many :messages

  def participants
    unless @participants.present?
      participants_ids = self.messages.group(:recipient_id, :sender_id).pluck(:recipient_id, :sender_id).flatten
      @participants ||= User.find(participants_ids)
    end

    @participants
  end

end
