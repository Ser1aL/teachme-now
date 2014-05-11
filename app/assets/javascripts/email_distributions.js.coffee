$ ->

  $('.add-email').click (e) ->
    e.preventDefault()
    $('.user-emails').after $('.user-email-field-template').html()

  $('.admin-text-insertable a').click (e) ->
    e.preventDefault()
    $('#email_text').html $(@).data('insertable-text')