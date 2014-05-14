$ ->
  $('.course-submit').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('false')
    $(@).closest('form').submit()

  $('.add-course-lesson').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('yes')
    $(@).closest('form').submit()

