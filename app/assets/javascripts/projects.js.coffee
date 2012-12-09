# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.update_estimates = (id_of_task, data) ->
  estimate_horizontal = $("#image_of_estimates_vertical_" + id_of_task)
  estimate_horizontal.find("img").attr("src", "/assets/estimate_" + data + "pt_fibonacci.gif")

  $("#estimates_label_" + id_of_task).html("start").show().addClass("label-success").attr("data-status", '1')
  $(".estimates_" + id_of_task).hide()
  labels_click_bind()


window.open_task_modal = (title_of_task) ->
  $('#task_modal').modal('show')
  $('#task_modal .modal-header h3').html(title_of_task)

send_form_on_select_assigned_to = () ->
  $("#task_assigned_to").live 'change', ()->
    $(this).parents(".accordion-inner").find("form").submit().end().find("input[type='text']").focus().select()


#window.update_me = (id_of_task) ->
  #  alert(id_of_task)

labels_click_bind = () ->

  $('.estimates_label').live 'click', ()->
    status = $(this).data('status')
    status_text = $(this).text()


    task_id = $(this).parents(".accordion-group").data("taskid")

    if status == 0
      $(this).next().show().end().hide()

    if status == 1
      task_id = $(this).parents(".accordion-group").data("taskid")


      next_status =  parseInt(status, 10) + 1

      $.ajax(
        url: "/tasks/" + task_id + "/update_points"
        type: "post",
        data:
          {'status': next_status}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )


$(document).ajaxComplete (xhr, data, status) ->
  #  console.log xhr
  #  console.log data
  #  console.log data.responseText

  if status.url.indexOf("tasks") > 0
    $(".users_stories").fadeTo("fast",".8", -> $(".users_stories").html(data.responseText).fadeTo("fast","1"))


#  if status.url.indexOf("/update_points") > 0
#    alert 444
#    task_id = status.url.split("/")[2]
#
#    $("#accordion_id").html("its test static message here:  333")
#    $("#accordion_id").html(data.responseText)




#    alert(data.resonseText())


$ ->
  labels_click_bind()
  send_form_on_select_assigned_to()

  $('span.estimates img').live 'click', (e) ->
    points = $(this).attr("rel")

    task_id = $(this).parents(".accordion-group").data("taskid")


    $.ajax(
      url: "/tasks/" + task_id + "/update_points"
      type: "post",
      data:
        {'points': points}
      headers:
        {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        }
    )


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

  $(".accordion-body").on "shown", ->
    $(this).parents(".accordion").find("input[type=text]").focus().select()
#    $("#discussion_title").focus().select()

  if location.hash == "#comments"
    $(".accordion-group.existed_discussions #collapseTwo").collapse('show')