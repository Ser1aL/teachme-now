class ProSubscriptionsController < ApplicationController

  before_filter :authenticate_user!, except: :create
  protect_from_forgery except: :create

  def create
    Rails.logger.info "-----PRO ONLY SIGNATURE RECEIVED #{params[:signature]}"
    status = Payment.create_liqpay_enrollment(params[:operation_xml])

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
      redirect_to root_path
    else
      notice = I18n.t('hints.payment_page.pro_payment_successful', transaction: status[:transaction], pro_due: status[:pro_due])
      redirect_to root_path, notice: notice
    end
  end

  def new
    @liqpay_tokens = Lesson.new.build_tokens(current_user.id)
  end

end
