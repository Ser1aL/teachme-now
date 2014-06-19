class ConversationsController < ApplicationController

  before_filter :verify_access, only: %w(show)

  def show
    @conversation = Conversation.includes(messages: %i(recipient sender)).find(params[:id])
    @recipient = (@conversation.participants - [current_user]).first
  end

  private

  def verify_access
    @conversation = Conversation.find(params[:id])

    unless @conversation.participants.include?(current_user)
      redirect_to root_path, notice: I18n.t('messaging.not_allowed')
    end
  end

end
