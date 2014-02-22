$ ->

  $('.contact-actions .action-item a').click (e) ->
    e.preventDefault()
    form_to_show = $(@).parent().data('form')
    $('.confirmation-form, .issues-form').hide()
    $(".#{form_to_show}").slideDown()
