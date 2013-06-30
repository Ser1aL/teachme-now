$(".without-password-nav a").click ->
  activeTab = $(this).attr("href") #save the clicked links target
  if $(this).hasClass("active")
    $(".without-password-nav a").removeClass "active" # remove pre-highlighted tabs
    $(".without-password-block").slideUp 500 # again hide pre-showing div
  else
    $(".without-password-nav a").removeClass "active" # remove pre-highlighted tabs
    $(this).addClass "active" #set this link to highlight
    $(".without-password-block").hide() # again hide pre-showing div
    $(activeTab).slideDown 500 #match the target div &amp; show it
  false