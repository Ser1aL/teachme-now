ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "teachme.notifier@gmail.com",
  :password             => "teachme.notifier",
  :authentication       => "plain",
  :enable_starttls_auto => true
}