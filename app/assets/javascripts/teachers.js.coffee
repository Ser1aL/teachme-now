$ ->
  pathname = window.location.pathname.split("/") || null
  if pathname[1] == 'teachers' && pathname[2]
    id = pathname[2].split("%20")
    $("##{id.join('_')}").addClass('active')
  else if pathname[1] == 'teachers'
    $("#teacher_rating").addClass('active')