# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
    selector = $(this)
    list_id = selector.parent().data().id
    list = $('ul.root').find("li[data-id='" + list_id + "'] ul")
    console.log list
    if selector.css('background-position-y') == '-12px'
      selector.css('background-position-y', '0px')
      list.slideUp()
      selector.parent().height(16)
    else
      selector.css('background-position-y', '-12px')
      list.slideDown()
      selector.parent().height( 16 + list.find("li").size() * 31 )
