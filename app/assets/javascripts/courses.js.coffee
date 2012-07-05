$ ->
  $('#course_interest_id').change (event) ->
    selected_interest_id = $(this).find("option:selected").val()
    $("#course_sub_interest_id").html $("#interest_options_" + selected_interest_id).html()