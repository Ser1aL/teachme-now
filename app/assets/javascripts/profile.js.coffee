$ ->
#  $(".clickable_popover").popover(
#    trigger: "click"
#    html: true
#    content: ->
#      $(this).children("div").html()
#  ).click (e) ->
#    e.preventDefault()

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

  $("#jsRatingVote a").click ->
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
