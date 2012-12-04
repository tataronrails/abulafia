# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/





window.update_estimates = (id_of_task, data) ->
  estimate_horizontal = $("#image_of_estimates_vertical_"+id_of_task)
  estimate_horizontal.find("img").attr("src","/assets/estimate_"+data+"pt_fibonacci.gif")

  $("#estimates_label_"+id_of_task).html("start").show()
  $(".estimates_"+id_of_task).hide()


window.open_task_modal = (title_of_task) ->
  $('#task_modal').modal('show')
  $('#task_modal .modal-header h3').html(title_of_task)

window.update_me = (id_of_task) ->
  #  alert(id_of_task)

$ ->
  $('span.estimates img').live 'click', (e) ->
    points = $(this).attr("rel")

    task_id = $(this).parents(".accordion-group").data("taskid")

    $.ajax(
      url: "/tasks/"+task_id+"/update_points"
      type: "post",
      data:
        {'points': points}
      headers:
        {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        }
    )

  $('.estimates_label').click ->
    $(this).next().show().end().hide()


  $(".estimate_me_class select").change ->
    estimate_of_task = $(this).val()
    $(this).attr("data-id")
    id_of_task = $(this).attr("data-id")

    form_of_estimation = $("form#edit_task_" + String(id_of_task))

    form_of_estimation.find("input[type='text']").val(estimate_of_task)

    console.log(form_of_estimation.find("input[type='text']").val())

    form_of_estimation.submit()


  $(".add_project_block a").click (e) ->
    $(".add_new_project_field").slideToggle("fast", -> $("#project_name").focus().select())
    e.preventDefault()
    ;

  $("#collapseOne").on "shown", ->
    $("#discussion_title").focus().select()

  if location.hash == "#comments"
    $(".accordion-group.existed_discussions #collapseTwo").collapse('show')