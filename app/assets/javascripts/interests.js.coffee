$ ->
  $('#interests_tab .sub-level li a').click (event) ->
    event.preventDefault()
    link_element = $(@)
    i_element = link_element.closest('li').find('i')
    yes_word = i_element.data('yes-word')
    no_word = i_element.data('no-word')
    $.ajax
      url: link_element.attr('href')
      data:
        trigger_to: !link_element.hasClass('checked')
      success: ->
        if link_element.hasClass('checked')
          i_element.html no_word
        else
          i_element.html yes_word

        link_element.toggleClass 'checked'