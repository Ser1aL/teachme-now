class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: %w(edit update map_interest update_email edit_password)
  before_filter :attach_errors_to_current_user, only: %w(update_email edit_password edit)
  layout false, only: %w(teacher_lessons student_lessons watchlist_lessons)

  helper :all

  def show
    @user = User.includes(:image_attachment, :leaders, :shares, skills: :sub_interest, followers: [:image_attachment, skills: :sub_interest]).where('id = ?' ,params[:id]).first
    @watchlist_lessons = User.get_watchlist_lessons(params[:id])
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      sign_in current_user, bypass: true
      redirect_to user_path(current_user), notice: I18n.t('notifications.profile_updated')
    else
      redirect_to :back, flash: { errors: current_user.errors }
    end
  end

  def interests
    @user = current_user
    @selected_interests = current_user.skills.includes(:sub_interest).map(&:sub_interest)
  end

  def map_interest
    if params[:trigger_to] == 'true'
      current_user.skills.where(sub_interest_id: params[:sub_interest_id]).first_or_create
    else
      current_user.skills.where(sub_interest_id: params[:sub_interest_id]).first.try(:destroy)
    end
    respond_with 1
  end

  def teacher_lessons
    @lessons = User.find(params[:user_id]).upcoming_teacher_lessons
    render 'users/tabs/teacher_lessons'
  end

  def student_lessons
    @user = User.find(params[:user_id])
    render 'users/tabs/student_lessons'
  end

  private
    def attach_errors_to_current_user
      flash[:errors].messages.each{ |key, value| current_user.errors[key] = value[0] } unless flash[:errors].blank?
    end
end
