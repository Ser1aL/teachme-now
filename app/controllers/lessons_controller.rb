class LessonsController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index index_by_page new search)
  before_filter :redirect_not_course_owner, only: %w(new_lesson create)
  before_filter :prepare_meta_data, :prepare_navigation, only: %w(index search)
  before_filter :modify_lesson_params, only: %w(create)

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
    params[:lesson][:duration] = params[:lesson][:hours].to_i * 60 + params[:lesson][:minutes].to_i
    params[:lesson][:level].downcase!
    render @lesson.update_attributes(params[:lesson].except(:hours, :minutes)) ? "show" : "edit"
  end

  def create
    if @course
      params[:lesson][:interest_id] = @course.interest_id
      params[:lesson][:sub_interest_id] = @course.sub_interest_id
    end
    @lesson = current_user.teacher_lessons.create(params[:lesson])

    # reset session to the passed params[:gallery_images], params[:attached_files]
    session[:image_attachments].try :map! do |image_attachment|
      image_attachment if params[:gallery_images].split('|').reject(&:blank?).include?(image_attachment[:image_attachment_id].to_s)
    end.try :compact!

    session[:file_attachments].try :map! do |file_attachment|
      file_attachment if params[:attached_files].split('|').reject(&:blank?).include?(file_attachment[:file_attachment_id].to_s)
    end.try :compact!

    if @lesson.new_record?
      render :action => 'new_lesson'
    else
      session[:image_attachments].try(:each) { |image_attachment| @lesson.image_attachments << ImageAttachment.find(image_attachment[:image_attachment_id]) }
      session[:file_attachments].try(:each) { |file_attachment| @lesson.file_attachments << FileAttachment.find(file_attachment[:file_attachment_id]) }
      @lesson.tag_list = params[:tags].split('|').reject(&:blank?).join(', ')
      @lesson.save

      session[:image_attachments] = []
      session[:file_attachments] = []
      redirect_to lesson_path(@lesson)
    end
  end

  def index
    @lessons = begin
      scope = Lesson.upcoming.by_page(params[:page]).includes(teachers: :image_attachment).includes(:interest, :sub_interest)
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
    @lessons = Lesson.slow_search(params[:query]).by_page(params[:page])
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
    @course = Course.find(params[:course_id]) if params[:course_id]
    @course = Course.find(params[:lesson][:course_id]) unless params[:lesson].try(:[], :course_id).blank?
    redirect_to root_path, notice: "You are not owner of this course" if @course && @course.user != current_user
  end

  def prepare_navigation
    # returns result set of { sub_interest_id: count }
    @lesson_counts = Lesson.upcoming.group(:sub_interest_id).count

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

  def modify_lesson_params
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
        place_price: params[:place_price]
    }

    if params[:start_time].present?
      params[:lesson][:start_datetime] = begin
        Time.parse(params[:start_time])
      rescue
        Time.now
      end
    end
  end
end
