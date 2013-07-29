jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  $(".clickable_popover").popover(
    trigger: "click"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $(".hover_popover").popover(
    trigger: "hover"
    html: true
    content: ->
      $(this).children("div").html()
  ).click (e) ->
    e.preventDefault()

  $("html").on "click.popover.data-api", (e) ->
    if $(e.target).has(".clickable_popover").length is 1
      $('.clickable_popover').popover "hide"

  $('.editable-div').click ->
    if $(@).hasClass('has-placeholder')
      $(@).html ''
      $(@).removeClass('has-placeholder')
    @contentEditable = true