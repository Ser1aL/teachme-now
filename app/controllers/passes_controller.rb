class PassesController < ApplicationController

  before_filter :authenticate_user!, except: :create
  before_filter :check_lesson_availability, only: %w(buy)
  protect_from_forgery except: :create

  LIQPAY_RESPONSE_URL = 'http://teach-me.com.ua/passes'

  respond_to :json

  def create
    status = Payment.create_liqpay_enrollment(params[:operation_xml])

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
      redirect_to root_path
    else
      redirect_to root_path, notice: I18n.t('hints.payment_page.payment_successful', transaction: status[:transaction], lesson_name: status[:lesson].name)
    end
  end

  def add_to_watchlist
    @lesson ||= Lesson.find(params[:lesson_id])

    @lesson.create_subscription(current_user)
    respond_with true
  end

  def buy
    @lesson = Lesson.find(params[:lesson_id])
    @liqpay_tokens = @lesson.build_tokens(LIQPAY_RESPONSE_URL, current_user.id)
  end

  private
    def check_lesson_availability
      @lesson = Lesson.find(params[:lesson_id])
      redirect_to lesson_path(@lesson) unless @lesson.buyable_for?(current_user)
    end

end
