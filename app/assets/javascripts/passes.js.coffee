$ ->

  $('.buy-pro').click (event) ->
    event.preventDefault()

    pro_selection = $('.pro-selection')
    if pro_selection.is(":visible")
      # hiding
      $(@).html $(@).data('withPro')
      pro_selection.slideUp()
      $(@).removeClass('btn-default')
      $(@).addClass('btn-success')
    else
      # making visible
      pro_selection.slideDown()
      $(@).html $(@).data('withoutPro')
      $(@).removeClass('btn-success')
      $(@).addClass('btn-default')
