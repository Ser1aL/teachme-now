class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: %w(edit update map_interest update_email edit_password)
  before_filter :attach_errors_to_current_user, only: %w(update_email edit_password edit)
  layout false, only: %w(teacher_lessons student_lessons watchlist_lessons connected_users)

  def show
    @user = User.find(params[:id])
    @followers = User.get_connected_users(params[:id], :followers)
    @watchlist_lessons = User.get_watchlist_lessons(params[:id])
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      sign_in current_user, bypass: true
      redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
    else
      redirect_to :back, flash: { errors: current_user.errors }
    end
  end

  def map_interest
    if params[:trigger_to] == 'true'
      current_user.skills.find_or_create_by_sub_interest_id(params[:sub_interest_id])
    else
      current_user.skills.find_by_sub_interest_id(params[:sub_interest_id]).destroy
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

  def connected_users
    @users = User.get_connected_users(params[:user_id], params[:connection_type])
    @page = params[:page].blank? ? 1 : params[:page].to_i
  end

  private
    def attach_errors_to_current_user
      flash[:errors].messages.each{ |key, value| current_user.errors[key] = value[0] } unless flash[:errors].blank?
    end
end
