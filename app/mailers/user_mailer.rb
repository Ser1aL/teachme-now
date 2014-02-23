class UserMailer < ActionMailer::Base
  default from: 'support@teach-me.com.ua'
  @queue = :mailer_queue

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
    @lesson = Lesson.find(lesson_id)
    @teacher = @lesson.teachers.first
    @comment = comment

    mail(to: @teacher.email, subject: 'issues').deliver
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
