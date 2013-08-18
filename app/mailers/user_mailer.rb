class UserMailer < ActionMailer::Base
  default from: 'support@teach-me.com.ua'

  def feedback(user_info)
    @user_info = user_info
    mail(to: 'max.reznichenko@gmail.com', subject: 'Feedback message')
  end
end
