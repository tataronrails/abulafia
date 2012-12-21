# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



#make_visible_2_backlog_button = (e) ->
#  $(".icebox_column .accordion-group").hover (=> console.log e), (=> console.log 2)

update_column_in_us_page = (proj_id, column_name, task_id) ->
  $.ajax(
    url: "/projects/" + proj_id + "/update_" + column_name,
    data:
      { 'task_id': task_id}
    success: (data) ->
      column_element = $("." + column_name + "_column")
      console.log column_element
      column_element.fadeTo("fast", ".6",-> column_element.html(data)).fadeTo("fast", "1")
      ;
  )


window.update_icebox_in_us_page = (proj_id) ->
  update_column_in_us_page(proj_id, "icebox")


window.update_backlog_in_us_page = (proj_id, task_id) ->
  update_column_in_us_page(proj_id, "backlog", task_id)

  $(".accordion-group").sortable()

window.update_my_work_in_us_page = (proj_id) ->
  update_column_in_us_page(proj_id, "my_work")


window.update_estimates = (id_of_task, data) ->
  estimate_horizontal = $("#image_of_estimates_vertical_" + id_of_task)
  estimate_horizontal.find("img").attr("src", "/assets/estimate_" + data + "pt_fibonacci.gif")

  $("#estimates_label_" + id_of_task).html("start").show().addClass("label-success").attr("data-status", '1')
  $(".estimates_" + id_of_task).hide()
  labels_click_bind()

delete_story = () ->
  $('.accordion-group i.icon-trash').live "click", () ->
    c = confirm("Sure?")
    if c
        $(this).parents(".accordion-group").slideUp("slow")

window.open_task_modal = (title_of_task) ->
  $('#task_modal').modal('show')
  $('#task_modal .modal-header h3').html(title_of_task)

send_form_on_select_assigned_to = () ->
  $("#task_assigned_to").live 'change', ()->
    if $("#task_title").val().length > 0
      $(this).parents(".accordion-inner").find("form").submit().end().find("input[type='text']").focus().select()


#window.update_me = (id_of_task) ->
#  alert(id_of_task)

labels_click_bind = () ->
  $('.estimates_label').live 'click', ()->
    #    story_id = $(this).attr("id").replace("estimates_label_","")
    status = $(this).data('status')
    status_text = $(this).text()
    project_id = $('body').data('project_id')


    task_id = $(this).parents(".accordion-group").data("taskid")


    if status == "to_backlog"
      $.ajax(
        url: "/tasks/" + task_id + "/to_backlog"
        type: "post",
        data:
          { 'project_id': project_id}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )




    if status == 0
      $(this).next().show().end().hide()


    if status == 1
      task_id = $(this).parents(".accordion-group").data("taskid")
      next_status =  parseInt(status, 10) + 1

      $.ajax(
        url: "/tasks/" + task_id + "/update_points"
        type: "post",
        data:
          {'status': next_status, 'project_id': project_id}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )

    if status == 2

      task_id = $(this).parents(".accordion-group").data("taskid")
      next_status =  parseInt(status, 10) + 1

      $.ajax(
        url: "/tasks/" + task_id + "/update_points"
        type: "post",
        data:
          {'status': next_status, 'project_id': project_id}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )

$(document).ajaxComplete (xhr, data, status) ->

  unless status.type == "DELETE"

      $(".users_stories").effect("fade", "fast")
      if status.url.indexOf("tasks") > 0 && status.url.indexOf("add_new_comment") < 0
        $(".users_stories").fadeTo("fast", ".8", -> $(".users_stories").html(data.responseText).fadeTo("fast", "1"))
        $("#task_title, #task_assigned_to").val("")
        $("#task_title").focus()

focus_on_ready_on_create_task = () ->
  $("#task_title").focus().select()

$ ->
  delete_story()
  focus_on_ready_on_create_task()
  #  task_create_advanced_settings()
  project_id = $('body').data('project_id')

  $('.backlog_column').sortable(
    update: (event, ui) ->
      backlogOrder = $(this).sortable('toArray').toString()

      $.ajax(
        url: "/tasks/update_order"
        type: "post",
        data:
          {'project_id': project_id, 'position_array': backlogOrder}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )


    #      $.get('update-sort.cfm', {fruitOrder:fruitOrder});
  )

  $.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader "Accept", "text/javascript"

  #  make_visible_2_backlog_button()
  labels_click_bind()
  #  send_form_on_select_assigned_to()

  $('span.estimates img').live 'click', (e) ->
    column_and_place = $(this).parents(".us_column").data("column")
    points = $(this).attr("rel")
    task_id = $(this).parents(".accordion-group").data("taskid")

    url_location = window.location.pathname


    $.ajax(
      url: "/tasks/" + task_id + "/update_points"
      type: "post",
      data:
        {'points': points}
      complete: (data) -> update_some_test_smth(data, column_and_place, url_location),
      headers:
        {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        }
    )

  update_some_test_smth = (data, column_and_place, url_location) ->
    if url_location.indexOf("/user_stories")
      project_id = $("body").data("project_id")

      switch column_and_place
      #        when 'icebox' then update_icebox_in_us_page(project_id)
        when 'backlog' then update_backlog_in_us_page(project_id)
        when 'my_work' then update_my_work_in_us_page(project_id)


  $(".estimate_me_class select").change ->
    estimate_of_task = $(this).val()
    $(this).attr("data-id")
    id_of_task = $(this).attr("data-id")

    form_of_estimation = $("form#edit_task_" + String(id_of_task))

    form_of_estimation.find("input[type='text']").val(estimate_of_task)

    #    console.log(form_of_estimation.find("input[type='text']").val())

    form_of_estimation.submit()


  $(".add_project_block a").click (e) ->
    $(".add_new_project_field").toggleClass("h")
    $("#project_name").focus().select()
    e.preventDefault()

  $(".accordion-body").on "shown", ->
    $(this).parents(".accordion").find("input[type=text]").focus().select()

  if location.hash == "#comments"
    $(".accordion-group.existed_discussions #collapseTwo").collapse('show')