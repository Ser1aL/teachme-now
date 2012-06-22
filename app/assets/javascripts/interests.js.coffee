$ ->
  $('#sub_interests li a').click (event) ->
    event.preventDefault()
    link_element = $(this)
    $.ajax
      url: link_element.attr('href')
      data:
        trigger_to: !link_element.hasClass('selected')
      success: (response) ->
        if link_element.hasClass('selected')
          link_element.removeClass('selected')
        else
          link_element.addClass('selected')