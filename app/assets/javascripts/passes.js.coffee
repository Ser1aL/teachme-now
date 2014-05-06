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
      $('.total b').html $('.initial-price').html()
      $('.charge-amount').val parseInt($('.initial-price').html())
      $('.order-id').val $('.order-id').data('pure-order-id')
    else
      # making visible
      pro_selection.slideDown()
      $(@).html $(@).data('withoutPro')
      $(@).removeClass('btn-success')
      $(@).addClass('btn-default')
      $('.chooser label[selected="selected"]').click()

  $('.chooser label').click ->
    $('.chooser label').removeAttr 'selected'
    $(@).attr 'selected', 'selected'
    pro_total = $(@).data('pro-total')
    pro_due = $(@).data('pro-due')
    pro_term = $(@).data('pro-term')

    # set pro subtotal
    $('.pro-price').html pro_total

    # set due
    $('.date_till').html pro_due
    $('.account-due').show()

    # set total
    total = parseInt($('.discount-price').html() || 0) + parseInt(pro_total)
    $('.order-id').val "#{$('.order-id').data('pure-order-id')}_#{pro_term}"
    $('.total b').html "#{total},00"
    $('.charge-amount').val total

  $('.chooser label.selected').click() if $('.chooser label.selected')

  $('.pay-button').click (e) ->
    e.preventDefault()
    $('.pay-form').submit()