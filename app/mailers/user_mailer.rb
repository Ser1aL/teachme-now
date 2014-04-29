class UserMailer < ActionMailer::Base
  default from: 'support@teach-me.com.ua'
  @queue = :mailer_queue

  include BarcodeGenerator

  layout 'mailer'

  if Rails.env.development?
    INTERNAL_MAIL_LIST = %w(max.reznichenko@gmail.com)
  else
    INTERNAL_MAIL_LIST = %w(max.reznichenko@gmail.com apavljk@gmail.com)
  end

  # internal
  def feedback(user_info)
    @user_info = user_info
    mail(to: self.class::INTERNAL_MAIL_LIST, subject: 'Feedback message').deliver
  end

  def lesson_created(lesson_id)
    @lesson = Lesson.find(lesson_id)

    mail(to: self.class::INTERNAL_MAIL_LIST, subject: "New lesson created #{@lesson.name}").deliver
  end

  def lesson_updated(lesson_id)
    @lesson = Lesson.find(lesson_id)

    mail(to: self.class::INTERNAL_MAIL_LIST, subject: "Lesson updated #{@lesson.name}").deliver
  end

  # customers
  def welcome(user_id)
    @header_icon = 'mail_welcome_icon.jpg'
    @user = User.find(user_id)

    mail(to: @user.email, subject: I18n.t('mailer.welcome.subject')).deliver
  end

  def lesson_confirmation(lesson_id, comment = nil)
    @header_icon = 'mail_message_icon.jpg'
    @lesson = Lesson.find(lesson_id)
    @teacher = @lesson.teachers.first
    @comment = comment

    mail(to: @teacher.email, subject: I18n.t('mailer.lesson_confirmation.subject')).deliver
  end

  def lesson_issues(lesson_id, comment = nil)
    @header_icon = 'mail_message_icon.jpg'
    @lesson = Lesson.find(lesson_id)
    @teacher = @lesson.teachers.first
    @comment = comment

    mail(to: @teacher.email, subject: I18n.t('mailer.lesson_issues.subject')).deliver
  end

  def user_lesson_bought(lesson_id, user_id)
    @header_icon = 'mail_message_icon.jpg'
    @lesson = Lesson.find(lesson_id)
    @user = User.find(user_id)

    receipt_file_path = generate_pdf_receipt(@lesson, @user)
    attachments['tickets-teach-me.pdf'] = File.read(receipt_file_path)

    mail(to: @user.email, subject: I18n.t('mailer.user_lesson_bought.subject')).deliver
  end

  def teacher_lesson_bought(lesson_id, user_id)
    @header_icon = 'mail_message_icon.jpg'
    @lesson = Lesson.find(lesson_id)
    @user = User.find(user_id)
    @teacher = @lesson.teacher
    @security_code = "TEACHME/#{lesson_id}#{(user_id.to_i * lesson_id.to_i) % 100 + user_id}/SECURED"

    mail(to: @teacher.email, subject: I18n.t('mailer.teacher_lesson_bought.subject')).deliver
  end

  def staff_lesson_bought(lesson_id, user_id)
    @header_icon = 'mail_message_icon.jpg'
    @lesson = Lesson.find(lesson_id)
    @user = User.find(user_id)

    mail(to: self.class::INTERNAL_MAIL_LIST, subject: I18n.t('mailer.staff_lesson_bought.subject')).deliver
  end

  # sync only
  def latest_suitable_lessons(user, lessons)
    @header_icon = 'mail_new_project_icon.jpg'
    @lessons = lessons
    @user = user

    mail(to: @user.email, subject: I18n.t('mailer.new_lessons.subject')).deliver
  end

  class << self

    def perform(method, *args)
      send(method, *args)
    end

    def async_send(method, *args)
      Resque.enqueue self, method, *args
    end

  end

end
