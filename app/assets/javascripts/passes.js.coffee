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
      $("#operation_xml").val $('.no-pro .payload').html()
      $("#signature").val $('.no-pro .signature').html()
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
    pro_total = $(@).data('proTotal')
    pro_due = $(@).data('proDue')
    pro_type = $(@).data('proType')
    # set pro subtotal
    $('.pro-price').html pro_total
    # set due
    $('.date_till').html pro_due
    $('.account-due').show()
    # set operation_xml
    $("#operation_xml").val $(".with-#{pro_type}-pro .payload").html()
    $("#signature").val $(".with-#{pro_type}-pro .signature").html()
    # set total
    total = parseInt($('.discount-price').html()) + parseInt(pro_total)
    console.log total
    $('.total b').html "#{total},00"

  $('.pay-button').click (e) ->
    e.preventDefault()
    $('.pay-form').submit()