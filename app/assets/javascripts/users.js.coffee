# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#not_social_link").click (event) ->
    event.preventDefault()
    $(".sign_in .form_wrapper").slideToggle()

  $(".submittable").click (event) ->
    event.preventDefault()
    $(this).closest("form").submit()

  $(".toggle_subscription").click (event) ->
    url = $(this)
    $.ajax
      url: url.attr("href")
      type: 'post'
      data:
        _method: url.data().method
      success: (response) ->
        url.html(response)
        if url.data().method == 'delete'
          new_method = 'post'
        else
          new_method = 'delete'
        url.data('method', new_method)
    false

  $(".toggle_rating").click (event) ->
    url = $(this)
    $.ajax
      url: url.attr("href")
      type: 'post'
      data:
        _method: url.data().method
      success: (response) ->
        url.html(response)
        if url.data().method == 'put'
          new_method = 'post'
        else
          new_method = 'put'
        url.data('method', new_method)
    false


