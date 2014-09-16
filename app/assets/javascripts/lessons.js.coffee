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

  # textarea auto resize
  $(".comments-form textarea").autosize()

  $(".comments-form textarea").focus ->
    height = $(@).data('height') || 60
    height = 60 if $(@).val() == ''
    $(@).height(height).css('min-height', 60)

  $(".comments-form textarea").focusout ->
    $(@).data 'height', $(@).height()
    $(@).height(20).css('min-height', 'initial')

  # datetime picker init
  $("#lesson_start_datetime").datetimepicker({ dateFormat: "yy-m-d", timeFormat: 'hh:mm'  })

  # load share buttons
  load_shared_buttons()

  $(".comments-form form").submit (event) ->
    form = $(@)
    event.preventDefault()
    form.find(".submit").attr("disabled", "disabled")
    $.ajax
      url: $(this).attr('action')
      data: form.serialize()
      type: 'post'
      success: (response) ->
        if response
          form.closest('.comments-column').find('.comments-box').append response
          form[0].reset()
        form.closest('.comments-column').find('.comments-box').removeClass('hide')

  $(".custom-content-popover").popover(
    trigger: "click"
    html: true
    content: -> $(@).parent().find('.custom-content-popover-body').html()
  ).click (e) -> e.preventDefault()

  $("#sale_enabled").on 'switchChange.bootstrapSwitch', (event, state) ->
    if state
      $('.adjustment-strategy-row').slideDown()
    else
      $('.adjustment-strategy-row').slideUp()

  $('.with-wysihtml5').wysihtml5
    'font-styles': false #Font styling, e.g. h1, h2, etc. Default true
    'emphasis': true #Italics, bold, etc. Default true
    'lists': true #(Un)ordered lists, e.g. Bullets, Numbers. Default true
    'html': false #Button which allows you to edit the generated HTML. Default false
    'link': false #Button to insert a link. Default true
    'image': false #Button to insert an image. Default true,
    'color': false #Button to change color of font
    'locale': "ru-RU"
#    customTemplates:
#      html: (locale) ->
#        "<li><div class='btn-group'><a class='btn' data-wysihtml5-action='change_view' title='" + locale.html.edit + "'>HSTML</a></div></li>"

  $('#certificates_add_button').click (event) ->
    event.preventDefault()

    if $('.js_certificates').find('.certificate_field').length < $('#capacity').val()
      certificate_id = $('.js_certificates').find('.certificate:last').attr('id')
      console.log $('#capacity').val()
      id = 1
      if certificate_id != undefined then id = parseInt(certificate_id.match(/\d+/)[0]) + 1

      html = "<div class='certificate_field'><input style='width:200px' class='text-input input-full-width certificate' "
      html += "data-placement='left' id='certificate_#{id}' name='certificates[cert_#{id}]' "
      html += "type='text' placeholder='Например: gift12345'>"
      html += "<i title='Remove' class='icon-remove remove_certificate'></i></div>"

      $('.js_certificates').append(html)
    else
      $('#certificates_add_button').attr('disabled', 'disabled')

    $('.remove_certificate').click (event) ->
      event.preventDefault()
      $(@).closest('.certificate_field').remove()
      $('#certificates_add_button').attr('disabled', false)

  $('.remove_certificate').click (event) ->
    event.preventDefault()
    $(@).closest('.certificate_field').remove()
    $('#certificates_add_button').attr('disabled', false)

  $('#capacity').change (event) ->
    if $('.js_certificates').find('.certificate_field').length >= $(@).val()
      console.log $(@).val()