class UserMailer < ActionMailer::Base
  default from: 'support@teach-me.com.ua'

  def feedback(user_info)
    @user_info = user_info
    mail(to: ['max.reznichenko@gmail.com', 'apavljk@gmail.com'], subject: 'Feedback message')
  end

  def lesson_created(lesson)
    @lesson = lesson
    mail(to: ['max.reznichenko@gmail.com', 'apavljk@gmail.com'], subject: "New lesson created #{@lesson.name}")
  end

  def welcome(user)
    @user = user
    mail(to: user.email, subject: I18n.t('mailer.welcome.subject'))
  end
end
