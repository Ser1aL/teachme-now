class CoursesController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)
  before_filter :preload_interest_tree, only: %w(edit new create update)
  before_filter :mark_message_notification, only: %w(show)
  before_filter :prepare_course_params, only: %w(create update)
  before_filter :redirect_not_course_owner, only: %w(edit update)

  helper :all

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      @course.tag_list = params[:tags]
      @course.save
      if params[:proceed_to_lesson_form] == 'yes'
        flash[:notice] = I18n.t('notifications.course_saved_add_lesson')
        redirect_to new_course_lesson_lessons_path(@course)
      else
        flash[:notice] = I18n.t('notifications.course_saved')
        redirect_to course_path(@course)
      end
    else
      redirect_to :back, flash: { errors: current_user.errors }
    end
  end

  def create
    @course = Course.create(params[:course].merge({owner_id: current_user.id}))
    if @course.new_record?
      render :action => 'new'
    else
      flash[:notice] = I18n.t('notifications.course_saved')
      @course.tag_list = params[:tags]
      @course.save
      if params[:proceed_to_lesson_form] == 'yes'
        redirect_to new_course_lesson_lessons_path(@course)
      else
        redirect_to course_path(@course)
      end
    end
  end

  private
  def preload_interest_tree
    @interests = Interest.includes(:sub_interests)
  end

  def mark_message_notification
    if params[:mnid]
      message_notification = MessageNotification.find(params[:mnid])
      message_notification.update_attribute(:is_read, true) if message_notification.user == current_user
    end
  end

  def redirect_not_course_owner
    @course = Course.find(params[:id])
    redirect_to root_path, notice: 'You are not owner of this course' if @course.user != current_user
  end

  def prepare_course_params
    params[:course] = {
        interest_id: params[:interest_id],
        sub_interest_id: params[:sub_interest_id],
        name: params[:title],
        description: params[:description],
        times_per_week: 1,
        city: 'Odessa'
    }
  end
end