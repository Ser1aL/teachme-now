class SubscriptionsController < ApplicationController

  def create
    subscription = Subscription.new(params[:subscription])
    if subscription.save
      redirect_to :back, notice: t('greet.successful')
    else
      redirect_to :back, notice: t('greet.email_not_valid')
    end
  end

end
