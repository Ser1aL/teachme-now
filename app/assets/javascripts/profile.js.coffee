$ ->
  $(".signers-list > li[data-toggle=popover]").popover(
    trigger: "click"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $("#jsComingLessonsToggle").click ->
    btnText = (if ($(this).text() is "Скрыть") then "Показать" else "Скрыть")
    $(this).text btnText
    $(".coming-lessons").slideToggle 500
    false

  $(".user-nav li[data-toggle=popover]").popover(
    trigger: "click"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $(".user-link-holder").click ->
    $(".user-link").toggleClass "infocus"
    false

  $(".message-link-holder").click ->
    $(".message-link").toggleClass "infocus"
    false

  $(".add-btn[data-toggle=popover]").popover(
    trigger: "click"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $(".pro[data-toggle=popover]").popover(
    trigger: "click"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $(".person-list li[data-toggle=popover]").popover
    trigger: "hover"
    html: true
    content: ->
      $(this).children("div").html()

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
