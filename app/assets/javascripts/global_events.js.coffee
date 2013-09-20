$ ->

  $('.flash-alert, .flash-notice').slideDown()
  $('.flash-alert .close, .flash-notice .close').click -> $(@).parent().slideUp()