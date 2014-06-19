class MessagesController < ApplicationController

  before_filter :verify_access, only: %w(create)

  def create
    message = Message.new(message_params)
    message.sender = current_user
    message.create_conversation if message.conversation.blank?

    if message.save
      flash[:notice] = I18n.t('messaging.added')
    else
      flash[:error] = I18n.t('messaging.error_adding_message')
    end

    redirect_to conversation_path(message.conversation)
  end

  private

  def verify_access
    message = Message.new(message_params)
    conversation = message.conversation

    if message.recipient.blank?
      # break in attempt
      redirect_to root_path, notice: I18n.t('messaging.not_allowed') and return
    end

    if conversation.present?
      # This is existing conversation.
      # Make sure both sender and recipient are part of it
      if (conversation.participants - [current_user, message.recipient]).present?
        redirect_to root_path, notice: I18n.t('messaging.not_allowed')
      end
    end
  end

  def message_params
    params.require(:message).permit(:conversation_id, :body, :recipient_id)
  end

end
