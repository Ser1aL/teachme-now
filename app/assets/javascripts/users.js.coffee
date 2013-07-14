$ ->
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

  $('#togglesubscribe').click (e) ->
    console.log 'me clicked'
    e.preventDefault()

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
