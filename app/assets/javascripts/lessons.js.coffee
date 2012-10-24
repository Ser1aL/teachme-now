# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggle_interest = (selector, force_open = false) ->
  list_id = selector.parent().data().id
  list = $('ul.root').find("li[data-id='" + list_id + "'] ul")

  if selector.hasClass('is_opened') && !force_open
    selector.removeClass('is_opened').addClass('is_closed')
    list.slideUp()
    selector.parent().height(16)
  else
    selector.removeClass('is_closed').addClass('is_opened')
    list.slideDown()
    selector.parent().height( 16 + list.find("li").size() * 31 )

$ ->
  $('#lesson_interest_id').change (event) ->
    selected_interest_id = $(this).find("option:selected").val()
    $("#lesson_sub_interest_id").html $("#interest_options_" + selected_interest_id).html()

  $('#add_to_watchlist form').submit (event) ->
    event.preventDefault()
    form = $(this)
    $.ajax
      url: form.attr("action")
      data:
        lesson_id: $(this).find("input[name=lesson_id]").val()
      success: (response) ->
        if(response == true)
          form.find("input[type=submit]").val("Added to watchlist").attr("disabled", "disabled")

  $('.switch .image').click ->
    toggle_interest $(this)

  selected_category = $('#navigation .opened')
  if selected_category && selected_category.html()
    interest_id = selected_category.html().trim()
    selector = $.find(".switch[data-id='" + interest_id + "'] .image")
    toggle_interest $(selector)


  $("#load_more_lessons").click (event) ->
    event.preventDefault()
    element = $(this)
    return if element.data().disabled
    element.data 'disabled', true
    element.html element.data().loading_message
    $.ajax
      url: "/lessons/index_by_page"
      data:
        interest_id: element.data().interest_id
        sub_interest_id: element.data().sub_interest_id
        page: element.data().page
      success: (response) ->
        if response.length > 1
          element.data('page', element.data().page + 1)
          $("#lessons #dynamic").append response
        if $(".invisible", response).size() == 3
          element.data('disabled', false)
          element.html element.data().message
        else
          element.remove()
        $('html,body').animate {scrollTop: 153 + $("#lessons").height() + 180 * 3 }, 'slow'
