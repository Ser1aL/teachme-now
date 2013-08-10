$ ->

  $(".select-inline").selectBox()

  window.getSelectedText = ->
    t = ""
    if window.getSelection
      t = window.getSelection()
    else if document.getSelection
      t = document.getSelection()
    else if document.selection
      t = document.selection.createRange().text
    else
      t = null
    t

  window.replaceSelectedText = (replacementText) ->
    sel = undefined
    range = undefined
    if window.getSelection
      sel = window.getSelection()
      if sel.rangeCount
        range = sel.getRangeAt(0)
        range.deleteContents()
        range.insertNode document.createTextNode(replacementText)
    else if document.selection and document.selection.createRange
      range = document.selection.createRange()
      range.text = replacementText

  Array::match_remove = (v) ->
    $.grep @,(e)->e!=v

  bind_remove_events = ->
    $('.remove').click (event) ->
      event.preventDefault()
      remove_link = $(@)
      tag_to_remove = remove_link.parent().find('span').html()
      remove_link.parent().remove()

      tag_holder = $(".tags-appender-box input[type='hidden']")
      tag_array = tag_holder.val().split('|')
      new_tag_array = tag_array.match_remove(tag_to_remove)
      tag_holder.val new_tag_array.join('|')

    $('.remove-file').click (event) ->
      event.preventDefault()
      remove_link = $(@)
      remove_link.parent().remove()

  $("#category-select").change ->
    selected_option = $(this).find('option:selected').html()
    sub_interests = $('.category-select').data('interests')[selected_option]

    $('#section-select').selectBox('destroy').html('')
    for sub_interest in sub_interests
      option = $('<option></option>').val(sub_interest[1]).html(sub_interest[0])
      $('#section-select').append(option)

    $('#section-select').selectBox()

  $(".tags-appender input[type='text']").keypress (e) ->
    if e.which is 13
      e.preventDefault()
      $('.tags-appender a').click()


  $('.tags-appender a').click (event) ->
    event.preventDefault()
    tag = $(".tags-appender input[type='text']").val()
    return false if tag.length == 0

    tag_holder = $(".tags-appender-box input[type='hidden']")
    tag_holder.val "#{tag_holder.val()}|#{tag}"
    $(".tags-appender input[type='text']").val ''

    tag_item = $('<div></div>').addClass('tag-item')
    tag_item.append $('<span></span>').html(tag)
    tag_item.append $('<a></a>').addClass('remove').attr('href', '#')
    tag_item.insertBefore $('.tags-appender')

    bind_remove_events()

  bind_remove_events()

  $("#lesson_file_attachment").fileupload
    add: (e, data) ->
      e.preventDefault()
      url = $("#lesson_file_attachment").data('url')
      $("#lesson_file_attachment .progress .bar").css("width", "0%")
      $("#lesson_file_attachment .progress").fadeIn()
      data.context = $(tmpl("lesson_file", data.files[0]))
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        $("#lesson_file_attachment .progress .bar").css("width", progress + '%')

    complete: (e, data) ->

      download_file_link = $.parseJSON(e.responseText).file_attachment_path
      $("#lesson_file_attachment .progress").fadeOut()

      if download_file_link && download_file_link.length > 0
        li = $('<li></li>')
        file_link = $('<a></a>').attr('href', download_file_link).html(download_file_link)
        remove_link = $('<a></a>').attr('href', '#').addClass('remove-file')
        $("#attached_files").append li.append(file_link).append(remove_link)

        bind_remove_events()

  $("#gallery-image-attachment").fileupload
    add: (e, data) ->
      e.preventDefault()
      url = $("#gallery-image-attachment").data('url')
      $("#gallery-image-attachment .progress .bar").css("width", "0%")
      $("#gallery-image-attachment .progress").fadeIn()
      data.context = $(tmpl("lesson_file", data.files[0]))
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        $("#gallery-image-attachment .progress .bar").css("width", progress + '%')

    complete: (e, data) ->

      response = $.parseJSON(e.responseText)
      download_file_link = response.image_attachment_path
      image_url = response.image_url
      attachment_id = response.image_attachment_id
      $("#gallery-image-attachment .progress").fadeOut()

      if download_file_link && download_file_link.length > 0
        li = $('<li></li>')
        file_link = $('<a></a>').attr('href', download_file_link).html(download_file_link)
        remove_link = $('<a></a>').attr('href', '#').addClass('remove-2')
        $("#gallery-images").append li.append(file_link).append(remove_link)
        $('#gallery-carousel .carousel-inner').append $('<div></div>').addClass('item').append("<img src='#{image_url}'>").data('attachment_id', attachment_id)
        setTimeout(->
          setTimeout(->
            $('#gallery-carousel .carousel-inner .item.blank').remove()
          , 1000)
        , 1000)

        bind_remove_events()

  $('.editable-div').click ->
    if $(@).hasClass('has-placeholder')
      $(@).html ''
      $(@).removeClass('has-placeholder')
    $('.editable-div.last-edited').removeClass('last-edited')
    $(@).addClass 'last-edited'
    try
      @contentEditable = "plaintext-only"
    catch exception
      @contentEditable = true
      $(@).focus()

#  bind_symbol_removal_events = ->
#    $('span.symbol').on 'remove', ->
#      console.log 'trigger remove'
#
#
#  $('.tag-edit').click (e) ->
#    e.preventDefault()
#
#    tag = $(@).data('tagType')
#    text = getSelectedText().toString()
#    text = '&nbsp;&nbsp;' if text.length == 0
#
#    opening = "<span class='symbol'>&lt;#{tag}&gt;</span>"
#    main_tag = "<#{tag}>#{text}</#{tag}>"
#    closing = "<span class='symbol'>&lt;/#{tag}&gt;</span>"
#
#    if $('.last-edited').hasClass('has-placeholder')
#      $('.last-edited').html ''
#      $('.last-edited').removeClass('has-placeholder')
#
#    $('.last-edited').html $('.last-edited').html() + opening + main_tag + closing + '&nbsp;'
#
#    bind_symbol_removal_events()
