$ ->
  $('.course-submit').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('false')
    $('#course-description-holder').val $('.course-editable-div').html() unless $('.course-editable-div').hasClass('has-placeholder')
    $(@).closest('form').submit()

  $('.add-course-lesson').click (e) ->
    e.preventDefault()
    $('.proceed-to-lesson-form').val('yes')
    $('#course-description-holder').val $('.course-editable-div').html() unless $('.course-editable-div').hasClass('has-placeholder')
    $(@).closest('form').submit()

