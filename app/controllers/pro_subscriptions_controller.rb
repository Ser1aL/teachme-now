class ProSubscriptionsController < ApplicationController

  before_filter :authenticate_user!, except: :create
  protect_from_forgery except: :create

  def create
    status = Payment.create_liqpay_enrollment(params)

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
    else
      # TODO send user confirmation
      flash[:notice] = I18n.t('hints.payment_page.pro_payment_successful', transaction: status[:transaction], pro_due: status[:pro_due])
    end

    # redirection is handled by LiqPay
    render nothing: true
  end

  def new
  end

end
