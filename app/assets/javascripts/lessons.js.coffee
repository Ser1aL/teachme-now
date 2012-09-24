# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggle_interest = (selector, force_open = false) ->
  list_id = selector.parent().data().id
  list = $('ul.root').find("li[data-id='" + list_id + "'] ul")

  if selector.css('background-position-y') == '-12px' && !force_open
    selector.css('background-position-y', '0px')
    list.slideUp()
    selector.parent().height(16)
  else
    selector.css('background-position-y', '-12px')
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

  $(".buy_pass").click ->
    location.href = $(this).data().buy_pass_path

  $("#load_more_lessons form").submit (event) ->
    form = $(this)
    event.preventDefault()
    page_input = form.find("input[name=page]")
    form.find("input[type=submit]").attr 'disabled', 'disabled'
    $.ajax
      url: "/lessons/index_by_page"
      data:
        interest_id: form.find("input[name=interest_id]").val()
        sub_interest_id: form.find("input[name=sub_interest_id]").val()
        page: page_input.val()
      success: (response) ->
        if response.length > 1
          page_input.val parseInt(page_input.val()) + 1
          $("#lessons").append response

        if $(".invisible", response).size() == 3
          form.find("input[type=submit]").removeAttr 'disabled'
        else
          form.find("input[type=submit]").remove()

