# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

load_user_tabs = ->
  active_tab = $ ".main .profile .tabs .tab.active"
  if active_tab.length > 0
    $(".right .ajax_loader").removeClass "invisible"
    $(".profile .content").html ""
    url = active_tab.data().url
    $.ajax
      url: url
      type: 'get'
      success: (response) ->
        $(".profile .content").html response
        $(".right .ajax_loader").addClass "invisible"
        activate_subscription_links()
        activate_load_more_button()

activate_load_more_button = ->
  $(".connected_users_wrapper .user_connections_bottom .more_loadable").click ->
    button = $ this
    button.html button.data().loading
    $.ajax
      url: button.data().url
      data:
        page: button.data().page
      success: (response) ->
        $(".profile .right .content").html response
        activate_load_more_button()
        activate_subscription_links()

activate_subscription_links = ->
  $(".connected_user .info .management .subscribe, .connected_user .info .management .unsubscribe").click (event) ->
    event_handler = $ this
    url = event_handler.find("a")
    $.ajax
      url: url.attr("href")
      type: 'post'
      data:
        _method: url.data().method
        connection_type: url.data().connection_type
      success: (response) ->
        totals = url.closest(".connected_users_wrapper").find(".totals b")
        if url.data().connection_type == 'followers'
          totals.html(parseInt(totals.html()) - 1)
          url.closest(".connected_user").remove()
        else
          totals.html if event_handler.hasClass("subscribe") then parseInt(totals.html()) + 1 else parseInt(totals.html()) - 1
          url.closest(".management").find(".subscribe, .unsubscribe").removeClass "invisible"
          url.closest("div").addClass("invisible")
    false

$ ->
  $("#not_social_link").click (event) ->
    event.preventDefault()
    $(".sign_in .form_wrapper").slideToggle()

  $(".submittable").click (event) ->
    event.preventDefault()
    $(this).closest("form").submit()

  $(".clickable").click (event) ->
    event.preventDefault()
    document.location = $(this).closest("a").attr("href")

  $(".vote_up, .vote_down").click (event) ->
    element = $ this
    return if element.hasClass 'disabled'
    $.ajax
      url: $(this).data().url
      type: 'post'
      data:
        _method: $(this).data().method
      success: (response) ->
        $(".vote_up, .vote_down").removeClass "disabled"
        element.addClass "disabled"
        $(".rating .value").html response.rating

  load_user_tabs()

  $(".tabs .tab").click (event) ->
    $(".tabs .tab.active").removeClass "active"
    $(this).addClass "active"
    load_user_tabs()

  $(".profile .left .subscriptions .more_loadable").click ->
    $(".tabs #subscribers_tab").click()

  $(".profile .left .user_hover_hint .subscribe").click (event) ->
    event.preventDefault()
    url = $(this).find("a")
    $.ajax
      url: url.attr('href')
      type: 'post'
      success: (response) ->
        url.closest(".subscribe").slideUp()

  $("#new_image_attachment").fileupload
    add: (e, data) ->
      $(".progress .bar").css("width", "0%")
      $(".progress").fadeIn()
      data.context = $(tmpl("file_upload", data.files[0]))
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        $(".progress .bar").css("width", progress + '%')

    complete: (e, data) ->
      $(".progress").fadeOut()
      $(".user-sidebox .personal .illustration img").attr "src", $.parseJSON(e.responseText).image_url

  $(".avatar_management").click -> $("#image_attachment_image").click()

  $(".interests-category > a").click ->
    $(this).toggleClass "active"
    $(this).next(".sub-level").slideToggle 500
    false
