module MailerHelper
  def mailer_image_url(image)
    URI.join(root_url, image_path("mailer/#{image}"))
  end
end
