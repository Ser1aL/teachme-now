$ ->
  $('.course-submit').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('false')
    $(@).closest('form').submit()

  $('.add-course-lesson').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('yes')
    $(@).closest('form').submit()

  $('#allow_split_buy').change ->
    if $(@).attr('checked')
      $("#changeable_price").removeAttr('checked')
      $("#changeable_price").closest('.row-fluid').slideUp()
    else $("#changeable_price").closest('.row-fluid').slideDown()
