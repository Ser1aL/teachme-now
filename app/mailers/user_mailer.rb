class UserMailer < ActionMailer::Base
  default from: 'support@teach-me.com.ua'

  def feedback(user_info)
    @user_info = user_info
    mail(to: 'support@teach-me.com.ua', subject: 'Feedback message')
  end
end
