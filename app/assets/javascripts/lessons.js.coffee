# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.migrateMute = true

load_shared_buttons = ->
  if $(".vk_share").length > 0
    $.each $(".vk_share"), (index, vk_share_button_holder) ->
      vk_share_button_holder = $(vk_share_button_holder)
      url = vk_share_button_holder.data().url || location.href
      vk_share_button = VK.Share.button {
        # post content
        title: vk_share_button_holder.data().common_title
        description: vk_share_button_holder.data().lesson_name
        image: "http://teach-me.com.ua/assets/logo_vk_wall.png"
        noparse: true,
        url: url
      }, {
        # button formatting
        type: "round"
        text: vk_share_button_holder.data().button_text
      }
      vk_share_button_holder.html vk_share_button

$ ->
  $('#lesson_interest_id').change (event) ->
    selected_interest_id = $(this).find("option:selected").val()
    $("#lesson_sub_interest_id").html $("#interest_options_" + selected_interest_id).html()
    $("#lesson_sub_interest_id").closest(".select_input").html $("#lesson_sub_interest_id")
    $(".sub_interest").html($("#lesson_sub_interest_id")).find("select").removeClass("has_sb").sb()

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
        lessons = $("#lessons .lesson_wrapper")
        top_position = lessons.eq(-3).height() + lessons.eq(-2).height() + lessons.eq(-1).height()
        $('html,body').animate {scrollTop: $("#lessons").height() - top_position - 68 }, 'slow'
        # load new shared buttons
        load_shared_buttons()

  # textarea auto resize
  $("#comment_body").autosize()

  # select box init
  $(".select_input select").sb()

  # datetime picker init
  $("#lesson_start_datetime").datetimepicker({ dateFormat: "yy-m-d", timeFormat: 'hh:mm'  })

  # load share buttons
  load_shared_buttons()

  $(".comment_form form").submit (event) ->
    event.preventDefault()
    form_values = $(this).serialize()
    $(".comments_wrapper .submit_error").addClass 'invisible'
    $(".comments_wrapper .ajax_loader").removeClass 'invisible'
    $(this).find(".submit").attr("disabled", "disabled")
    $.ajax
      url: $(this).attr('action')
      data: form_values
      type: 'post'
      success: (response) ->
        if response
          $(".comments_wrapper .comments").append response
          $(".comment_form form")[0].reset()
        else
          $(".comments_wrapper .submit_error").removeClass 'invisible'
        $(".comments_wrapper .ajax_loader").addClass 'invisible'

  $(".side-nav > ul > li > a.active").parent().find(".sub-level").show()
  all_panels = $(".side-nav .sub-level")
  element = $(".side-nav > ul > li > a")
  element.click ->
    all_panels.slideUp()
    if $(this).hasClass("active")
      $(this).removeClass "active"
    else
      element.removeClass "active"
      $(this).addClass "active"
      $(this).parent().find(".sub-level").slideDown()
    false

  $("li[data-toggle=popover]").popover(
    trigger: "hover"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $(".carousel").carousel()