$ ->
  $('.paper-sheet .sub_interests ul li').click (event) ->
    event.preventDefault()
    link_element = $(this).find("a")
    li_element = $(this)
    $.ajax
      url: link_element.attr('href')
      data:
        trigger_to: !link_element.hasClass('selected')
      success: (response) ->
        if li_element.hasClass('selected')
          li_element.removeClass('selected')
        else
          li_element.addClass('selected')