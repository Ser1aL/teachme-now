$ ->
  data = $('.js_contacts_errors').data()
  if data
    if data.userName
      $('#user-name').closest('.control-group').addClass('error')
      $('.js_name_error').text(data.userName)

    if data.userEmail
      $('#user-mail').closest('.control-group').addClass('error')
      $('.js_mail_error').text(data.userEmail)

    if data.userMessage
      $('#user-message').closest('.control-group').addClass('error')
      $('.js_message_error').text(data.userMessage)
