class PassesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_lesson_availability, only: %w(create buy)

  respond_to :json

  def create
    @lesson ||= Lesson.find(params[:lesson_id])

    current_user.update_attributes(phone: params[:phone])
    if current_user.errors.blank?
      @lesson.create_enrollment(current_user)
      redirect_to lesson_path(@lesson)
    else
      redirect_to :back, notice: current_user.errors.messages
    end
  end

  def add_to_watchlist
    @lesson ||= Lesson.find(params[:lesson_id])

    @lesson.create_subscription(current_user)
    respond_with true
  end

  def buy
  end

  private
    def check_lesson_availability
      @lesson = Lesson.find(params[:lesson_id])
      redirect_to lesson_path(@lesson) unless @lesson.buyable_for?(current_user)
    end

end
