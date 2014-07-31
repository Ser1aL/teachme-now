class PassesController < ApplicationController
  before_filter :authenticate_user!, except: :create
  before_filter :check_lesson_availability, only: %w(buy)
  protect_from_forgery except: %i(create create_course)

  respond_to :json

  def create
    status = Payment.create_liqpay_enrollment(params)

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
    else
      if status[:pro_due].present?
        notice = I18n.t('hints.payment_page.payment_successful_with_pro', transaction: status[:transaction], lesson_name: status[:lesson].name, pro_due: status[:pro_due])
      else
        notice = I18n.t('hints.payment_page.payment_successful', transaction: status[:transaction], lesson_name: status[:lesson].name)
      end

      if status[:lesson].present?
        UserMailer.async_send(:user_lesson_bought, status[:lesson].id, status[:user].id)
        UserMailer.async_send(:teacher_lesson_bought, status[:lesson].id, status[:user].id)
        UserMailer.async_send(:staff_lesson_bought, status[:lesson].id, status[:user].id)
      end

      flash[:notice] = notice
    end

    # redirection is handled by LiqPay
    render nothing: true
  end

  def create_booking
    @lesson = Lesson.find(params[:lesson_id])
    if @lesson.bookable_for?(current_user)
      if !current_user.phone?
        current_user.update(phone: params[:user][:phone])

        if current_user.errors.present?
          redirect_to :back, notice: I18n.t('hints.book_page.phone_not_valid') and return
        end
      end

      if current_user.has_vk_email?
        current_user.update(email: params[:user][:email])

        if current_user.errors.present?
          redirect_to :back, notice: I18n.t('hints.book_page.email_not_valid') and return
        end
      end

      UserMailer.async_send(:user_lesson_booked, @lesson.id, current_user.id)
      UserMailer.async_send(:teacher_lesson_booked, @lesson.id, current_user.id)
      UserMailer.async_send(:staff_lesson_booked, @lesson.id, current_user.id)

      Share.create(user: current_user, lesson: @lesson, share_type: 'study')
      @lesson.increment!(:places_taken)
      redirect_to lesson_path(@lesson), notice: I18n.t('hints.book_page.lesson_booked')
    else
      redirect_to :back, notice: I18n.t('hints.book_page.lesson_unbookable')
    end
  end

  def create_course
    status = Payment.create_liqpay_course_enrollment(params)

    if status[:error].present?
      flash[:error] = I18n.t(status[:error])
    else
      if status[:course].present?
        status[:course].lessons.upcoming.enabled.each do |lesson|
          UserMailer.async_send(:user_lesson_bought, lesson.id, status[:user].id)
          UserMailer.async_send(:teacher_lesson_bought, lesson.id, status[:user].id)
          UserMailer.async_send(:staff_lesson_bought, lesson.id, status[:user].id)
        end
      end

    end
    # redirection is handled by LiqPay
    render nothing: true
  end

  def add_to_watchlist
    @lesson ||= Lesson.find(params[:lesson_id])

    @lesson.create_subscription(current_user)
    respond_with true
  end

  def buy
    @lesson = Lesson.find(params[:lesson_id])
  end

  def book
    @lesson = Lesson.find(params[:lesson_id])
  end

  def buy_course
    @course = Course.find(params[:course_id])
  end

  private
    def check_lesson_availability
      @lesson = Lesson.find(params[:lesson_id])
      unless @lesson.buyable_for?(current_user)
        redirect_to lesson_path(@lesson), notice: I18n.t('hints.payment_page.lesson_not_available')
      end

    end

end
