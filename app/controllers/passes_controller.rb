class PassesController < ApplicationController
  before_filter :authenticate_user!, except: :create
  before_filter :check_lesson_availability, only: %w(buy)
  protect_from_forgery except: :create

  respond_to :json

  def create
    status = Payment.create_liqpay_enrollment(params[:operation_xml])
    UserMailer.async_send(:user_lesson_bought, status[:lesson].id, status[:user].id)
    UserMailer.async_send(:teacher_lesson_bought, status[:lesson].id, status[:user].id)
    UserMailer.async_send(:staff_lesson_bought, status[:lesson].id, status[:user].id)

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
      redirect_to root_path
    else
      if status[:pro_due].present?
        notice = I18n.t('hints.payment_page.payment_successful_with_pro', transaction: status[:transaction], lesson_name: status[:lesson].name, pro_due: status[:pro_due])
      else
        notice = I18n.t('hints.payment_page.payment_successful', transaction: status[:transaction], lesson_name: status[:lesson].name)
      end
      redirect_to root_path, notice: notice
    end
  end

  def add_to_watchlist
    @lesson ||= Lesson.find(params[:lesson_id])

    @lesson.create_subscription(current_user)
    respond_with true
  end

  def buy
    @lesson = Lesson.find(params[:lesson_id])
    @liqpay_tokens = @lesson.build_tokens(current_user.id)
  end

  private
    def check_lesson_availability
      @lesson = Lesson.find(params[:lesson_id])
      unless @lesson.buyable_for?(current_user)
        redirect_to lesson_path(@lesson), notice: I18n.t('hints.payment_page.lesson_not_available')
      end

    end

end
