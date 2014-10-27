$ ->

  $('.all-signers-link').click (event) ->
    event.preventDefault()
    $(".signers-list > li").removeClass('hide')
    $(@).remove()

  $("#jsComingLessonsToggle").click ->
    btnText = (if ($(this).text() is "Скрыть") then "Показать" else "Скрыть")
    $(this).text btnText
    $(".coming-lessons").slideToggle 500
    false

  $(".user-link-holder").click ->
    $(".user-link").toggleClass "infocus"
    false

  $(".message-link-holder").hover ->
    $(".message-link").toggleClass "infocus"
    false

  $(".rating a").click (event) ->
    rate_id = $(@).closest('.rating').attr('id')
    element = $ this
    return false if element.hasClass 'disabled'

    $.ajax
      url: $(this).data().url
      type: 'post'
      data:
        _method: $(this).data().method
      success: (response) ->
        $(".vote-up, .vote-down").removeClass "disabled"
        element.addClass "disabled"
        $("##{rate_id} .value").html response.rating

    if $(this).is(".vote-up")
      $(this).siblings(".message-vote").addClass("up").show()
      setTimeout (->
        $(".message-vote").hide().removeClass "up"
      ), 800
    else
      $(this).siblings(".message-vote").addClass("down").show()
      setTimeout (->
        $(".message-vote").hide().removeClass "down"
      ), 800
    false
