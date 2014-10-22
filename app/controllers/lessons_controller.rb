class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index new search)
  before_filter :redirect_not_course_owner, only: %w(new_lesson create)
  before_filter :redirect_not_lesson_owner, only: %w(edit update)
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

  def new
    deprecated_route
  end

  def new_lesson
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.image_attachments = params[:gallery_images].split('|').reject(&:blank?).try(:map) { |id| ImageAttachment.find(id) } || []
    @lesson.file_attachments = params[:attached_files].split('|').reject(&:blank?).try(:map) { |id| FileAttachment.find(id) } || []
    remove_sensitive = @lesson.places_taken > 0

    if @lesson.update_attributes(lesson_params(remove_sensitive))
      @lesson.tag_list = params[:tags].split('|').reject(&:blank?).join(', ')
      @lesson.save
      flash[:notice] = @lesson.enabled? ? I18n.t('notifications.lesson_updated') : I18n.t('notifications.lesson_updated_disabled')
      UserMailer.async_send(:lesson_updated, @lesson.id)
      @lesson.certificates = params[:certificates].reject(&:blank?).uniq.try(:map) do |code|
        @lesson.certificates.where(code: code).first_or_create
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

    params.merge!(enabled: false)
    @lesson = current_user.teacher_lessons.new(lesson_params)

    @lesson.is_premium = true if current_user.pro_account_enabled?
    @lesson.image_attachments = params[:gallery_images].split('|').reject(&:blank?).try(:map) { |id| ImageAttachment.find(id) } || []
    @lesson.file_attachments = params[:attached_files].split('|').reject(&:blank?).try(:map) { |id| FileAttachment.find(id) } || []
    @lesson.certificates = params[:certificates].reject(&:blank?).uniq.try(:map) do |code|
      @lesson.certificates.where(code: code).first_or_create
    end

    @lesson.save

    if @lesson.new_record?
      render :action => 'new_lesson'
    else
      @lesson.tag_list = params[:tags].split('|').reject(&:blank?).join(', ')
      @lesson.teachers = [current_user]
      @lesson.save
      UserMailer.async_send(:lesson_created, @lesson.id)

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
    @lessons =
      begin
        scope = Lesson.index_page_scope.by_page(params[:page])
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
    @lessons = Lesson.index_page_scope.slow_search(params[:query]).by_page(params[:page])
    render :index
  end

  private

  def redirect_not_course_owner
    @course = Course.find(params[:course_id]) if params[:course_id].present?
    @course = Course.find(params[:lesson][:course_id]) unless params[:lesson].try(:[], :course_id).blank?
    redirect_to root_path, notice: 'You are not owner of this course' if @course && @course.user != current_user
  end

  def redirect_not_lesson_owner
    @lesson = Lesson.find(params[:id])
    redirect_to root_path, notice: 'You are not owner of this lesson' if @lesson.teacher != current_user
  end

  def prepare_navigation
    # returns result set of { sub_interest_id: count }
    @lesson_counts = Lesson.index_page_scope.inject({}) do |counts, lesson|
      counts[lesson.sub_interest_id] ||= 0
      counts[lesson.sub_interest_id] +=1
      counts
    end

    @selected_interest = @interests.select{ |interest| interest.to_param == params[:interest_id] }.first || @interests.first
    @selected_sub_interest = @selected_interest.sub_interests.select do |sub_interest|
      sub_interest.to_param == params[:sub_interest_id]
    end.first
  end

  def prepare_meta_data
    if params[:sub_interest_id]
      @pre_word = SubInterest.find(params[:sub_interest_id]).translation
    elsif params[:interest_id]
      @pre_word = @interests.find(params[:interest_id]).translation
    else
      @pre_word = I18n.t('meta.lessons.default_pre_word')
    end

  end

  def prepare_lesson_params
    if params[:lesson_type].eql?('course')
      if params[:permanent].eql?('on')
        publish_duration = params[:publish_duration]
        duration = 0
        start_time = Time.now + publish_duration.to_i.days
      else
        duration = params[:akademic_hours_duration].to_i.hours / 60
        start_time = params[:course_start_time]
      end
    elsif params[:lesson_type].eql?('lesson')
      duration = (
        params[:hours_duration].to_i.hours +
        params[:minutes_duration].to_i.minutes
      ) / 60
      start_time = params[:lesson_start_time]
    end

    params[:lesson] = {
        interest_id: params[:interest_id],
        sub_interest_id: params[:sub_interest_id],
        name: params[:title],
        city: 'odessa',
        address_line: params[:address_line],
        level: 'medium',
        duration: duration,
        description_top: params[:description_top],
        description_bottom: params[:description_bottom],
        capacity: params[:capacity],
        place_price: params[:place_price],
        course_id: params[:course_id],
        adjustment_used: params[:adjustment_used] == 'on',
        sale_enabled: params[:sale_enabled] == 'on',
        permanent: params[:permanent] == 'on' && params[:lesson_type].eql?('course'),
        publish_duration: publish_duration,
        start_datetime: start_time
    }
  end

  def lesson_params(remove_sensitive = false)
    lesson_keys = %i(
      interest_id sub_interest_id name city address_line level duration description_top
      description_bottom capacity place_price course_id adjustment_used enabled start_datetime sale_enabled
      publish_duration permanent
    )

    if remove_sensitive
      lesson_keys -= [:place_price, :start_datetime, :capacity, :address_line, :duration, :adjustment_used, :sale_enabled, :publish_duration]
    end

    params.require(:lesson).permit(lesson_keys)
  end

  def mark_message_notification
    if params[:mnid]
      message_notification = MessageNotification.find(params[:mnid])
      message_notification.update_attribute(:is_read, true) if message_notification.user == current_user
    end
  end
end
