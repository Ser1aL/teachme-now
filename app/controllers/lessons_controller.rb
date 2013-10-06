class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index index_by_page new search)
  before_filter :redirect_not_course_owner, only: %w(new_lesson create)
  before_filter :prepare_meta_data, :prepare_navigation, only: %w(index search)
  before_filter :prepare_lesson_params, only: %w(create update)
  before_filter :mark_message_notification, only: %w(show)

  def show
    @lesson = Lesson.
        where(id: params[:id]).
        includes(comments: :user).
        includes(:subscribed_users).
        includes(teachers: [:image_attachment, skills: :sub_interest]).
        includes(:interest, :sub_interest).
        includes(students: { skills: :sub_interest }).
        first
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.image_attachments = params[:gallery_images].split('|').reject(&:blank?).try(:map) { |id| ImageAttachment.find(id) } || []
    @lesson.file_attachments = params[:attached_files].split('|').reject(&:blank?).try(:map) { |id| FileAttachment.find(id) } || []

    params[:lesson].except!(:place_price) unless @lesson.enabled?
    params[:lesson].except!(:place_price, :start_datetime, :capacity, :address_line, :duration) if @lesson.places_taken > 0

    if @lesson.update_attributes(params[:lesson])
      @lesson.tag_list = params[:tags].split('|').reject(&:blank?).join(', ')
      @lesson.save
      if @lesson.enabled?
        flash[:notice] = I18n.t('notifications.lesson_updated')
      else
        flash[:notice] = I18n.t('notifications.lesson_updated_disabled')
      end
      redirect_to lesson_path(@lesson)
    else
      render 'edit'
    end
  end

  def create
    if @course
      params[:lesson][:interest_id] = @course.interest_id
      params[:lesson][:sub_interest_id] = @course.sub_interest_id
    end
    @lesson = current_user.teacher_lessons.new(params[:lesson].merge!(enabled: false))

    @lesson.is_premium = true if current_user.pro_account_enabled?
    @lesson.image_attachments = params[:gallery_images].split('|').reject(&:blank?).try(:map) { |id| ImageAttachment.find(id) } || []
    @lesson.file_attachments = params[:attached_files].split('|').reject(&:blank?).try(:map) { |id| FileAttachment.find(id) } || []

    @lesson.save

    if @lesson.new_record?
      render :action => 'new_lesson'
    else
      @lesson.tag_list = params[:tags].split('|').reject(&:blank?).join(', ')
      @lesson.teachers = [current_user]
      @lesson.save
      UserMailer.lesson_created(@lesson).deliver
      if @course
        flash[:notice] = I18n.t('notifications.lesson_created_added_to_course_disabled')
        redirect_to edit_course_path(@course)
      else
        flash[:notice] = I18n.t('notifications.lesson_created_disabled')
        redirect_to lesson_path(@lesson)
      end
    end
  end

  def index
    @lessons = begin
      scope = Lesson.unscoped.upcoming.enabled.by_page(params[:page]).includes(teachers: :image_attachment).includes(:interest, :sub_interest).order('is_premium desc, start_datetime desc')
      if params[:sub_interest_id]
        scope.where(sub_interest_id: params[:sub_interest_id])
      elsif params[:interest_id]
        scope.where(interest_id: params[:interest_id])
      else
        scope
      end
    end
  end

  def search
    @lessons = Lesson.enabled.slow_search(params[:query]).by_page(params[:page])
    render :index
  end

  def index_by_page
    @lessons = begin
      if params[:interest_id].present?
        if params[:sub_interest_id].present?
          Lesson.upcoming.where(interest_id: params[:interest_id], sub_interest_id: params[:sub_interest_id]).by_page(params[:page])
        else
          Lesson.upcoming.where(interest_id: params[:interest_id]).by_page(params[:page])
        end
      else
        Lesson.upcoming.by_page(params[:page])
      end
    end
    render @lessons, layout: false
  end

  private

  def redirect_not_course_owner
    @course = Course.find(params[:course_id]) if params[:course_id].present?
    @course = Course.find(params[:lesson][:course_id]) unless params[:lesson].try(:[], :course_id).blank?
    redirect_to root_path, notice: "You are not owner of this course" if @course && @course.user != current_user
  end

  def prepare_navigation
    # returns result set of { sub_interest_id: count }
    @lesson_counts = Lesson.enabled.upcoming.group(:sub_interest_id).count

    @selected_interest = @interests.select{ |interest| interest.to_param == params[:interest_id] }.first || @interests.first
    @selected_sub_interest = @selected_interest.sub_interests.select do |sub_interest|
      sub_interest.to_param == params[:sub_interest_id]
    end.first
  end

  def prepare_meta_data
    if params[:sub_interest_id]
      @pre_word = I18n.t("sub_interests.#{SubInterest.find(params[:sub_interest_id]).name}")
    elsif params[:interest_id]
      @pre_word = I18n.t("interests.#{@interests.find(params[:interest_id]).name}")
    else
      @pre_word = I18n.t('meta.lessons.default_pre_word')
    end

  end

  def prepare_lesson_params
    duration = (params[:hours_duration].to_i.hours + params[:minutes_duration].to_i.minutes) / 60
    params[:lesson] = {
        interest_id: params[:interest_id],
        sub_interest_id: params[:sub_interest_id],
        course_id: params[:course_id],
        name: params[:title],
        city: 'odessa',
        address_line: params[:address_line],
        level: 'medium',
        duration: duration,
        description_top: params[:description_top],
        description_bottom: params[:description_bot],
        capacity: params[:capacity],
        place_price: params[:place_price],
        course_id: params[:course_id]
    }

    if params[:start_time].present?
      params[:lesson][:start_datetime] = begin
        Time.parse(params[:start_time])
      rescue
        Time.now
      end
    end
  end

  def mark_message_notification
    if params[:mnid]
      message_notification = MessageNotification.find(params[:mnid])
      message_notification.update_attribute(:is_read, true) if message_notification.user == current_user
    end
  end
end
