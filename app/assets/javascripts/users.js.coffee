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
