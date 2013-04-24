# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


create_sprint_toggle = () ->

  $(".create_sprint_button").on "click", (event) ->
    event.preventDefault()
    $(".add_sprint_form").toggleClass("h")


filter_task_types = () ->
  $(".list_of_vis_links .btn-group a").click ->
    $(this).toggleClass("active")

    ttype = $(this).attr("id")

    switch ttype
      when "feature" then $(".accordion-group .icon-star-empty").parents(".accordion-group").slideToggle("fast")
      when "bug" then $(".accordion-group .icon-bolt").parents(".accordion-group").slideToggle("fast")
      when "chore" then $(".accordion-group .icon-cogs").parents(".accordion-group").slideToggle("fast")
      when "story" then $(".accordion-group .icon-star-half").parents(".accordion-group").slideToggle("fast")




hide_done_stories = () ->
  $(".toggle_done_tasks").on "click", () ->
    console.log $(".done_story:hidden").length

    if $(".done_story:hidden").length > 0
      $(".done_story").slideDown("fast")
    else
      $(".done_story").slideUp("fast")


window.accept_task = (task_id) ->
  c = confirm("Sure?")
  if c
    project_id = $('body').data('projectId')

    $.ajax(
      url: "/projects/"+project_id+"/tasks/" + task_id + "/update_points"
      type: "post",
      data:
        {'status': 6, 'project_id': project_id}
      headers:
        {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        }
    )
#  hide_done_stories()



#make_visible_2_backlog_button = (e) ->
#  $(".icebox_column .accordion-group").hover (=> console.log e), (=> console.log 2)

update_column_in_us_page = (proj_id, column_name, task_id) ->
  $.ajax(
    url: "/projects/" + proj_id + "/update_" + column_name,
    data:
      { 'task_id': task_id}
    success: (data) ->
      column_element = $("." + column_name + "_column")
#      console.log column_element
      column_element.fadeTo("fast", ".6",-> column_element.html(data)).fadeTo("fast", "1")

  )



window.update_icebox_in_us_page = (proj_id) ->
  update_column_in_us_page(proj_id, "icebox")


window.update_backlog_in_us_page = (proj_id, task_id) ->
  update_column_in_us_page(proj_id, "backlog", task_id)

  $(".accordion-group").sortable()



window.update_my_work_in_us_page = (proj_id) ->
  update_column_in_us_page(proj_id, "my_work")

window.update_current_work_in_us_page = (proj_id) ->
  update_column_in_us_page(proj_id, "current_work")


window.update_estimates = (id_of_task, data) ->
  estimate_horizontal = $("#image_of_estimates_vertical_" + id_of_task)
  estimate_horizontal.find("img").attr("src", "/assets/estimate_" + data + "pt_fibonacci.gif")

  $("#estimates_label_" + id_of_task).html("start").show().addClass("label-success").attr("data-status", '1')
  $(".estimates_" + id_of_task).hide()
  labels_click_bind()

delete_story = () ->
  $('.accordion-group i.icon-trash').on "click", () ->
    c = confirm("Sure?")
    if c
      $(this).parents(".accordion-group").slideUp("slow")

window.open_task_modal = (title_of_task) ->
  $('#task_modal').modal('show')
  $('#task_modal .modal-header h3').html(title_of_task)

send_form_on_select_assigned_to = () ->
  $("#task_assigned_to").on 'change', ()->
    if $("#task_title").val().length > 0
      $(this).parents(".accordion-inner").find("form").submit().end().find("input[type='text']").focus().select()


#window.update_me = (id_of_task) ->
#  alert(id_of_task)

labels_click_bind = () ->
  $('.estimates_label').on 'click', ()->
    #    story_id = $(this).attr("id").replace("estimates_label_","")
    status = $(this).data('status')
    status_text = $(this).text()
    project_id = $('body').data('projectId')


    task_id = $(this).parents(".accordion-group").data("taskid")


    if status == "to_backlog"
      $.ajax(
        url:  "/projects/"+project_id+"/tasks/" + task_id + "/to_backlog"
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
      $(this).parents(".accordion-group").find(".estimates").show()
      $(this).hide()


    if status == 1
      task_id = $(this).parents(".accordion-group").data("taskid")
      next_status =  parseInt(status, 10) + 1

      $.ajax(
        url: "/projects/"+project_id+"/tasks/" + task_id + "/update_points"
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
        url: "/projects/"+project_id+"/tasks/" + task_id + "/update_points"
        type: "post",
        data:
          {'status': next_status, 'project_id': project_id}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )

    #pushed
    if status == 3

      task_id = $(this).parents(".accordion-group").data("taskid")
      next_status =  parseInt(status, 10) + 1

      $.ajax(
        url: "/projects/"+project_id+"/tasks/" + task_id + "/update_points"
        type: "post",
        data:
          {'status': next_status, 'project_id': project_id}
        headers:
          {
          'X-Transaction': 'POST Example',
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }
      )

#    console.log(hours_worked_on_task) if hours_worked_on_task

    #testing
    if status == 4

      task_id = $(this).parents(".accordion-group").data("taskid")
      next_status =  parseInt(status, 10) + 1

      task_id = $(this).parents(".accordion-group").data("taskid")
      hours = $(this).parents(".accordion-group").find(".hours_" + task_id)
#      console.log hours
      hours.removeClass("h")
      hours.find("input#hours_worked_on_task").focus()
      $(this).hide()


$(document).ajaxComplete (xhr, data, status) ->
  unless status.type == "DELETE" || data.status == 500

    if status.url.indexOf("sprint") > 0
      $(".sprints_show").html(data.responseText)
    else
      $(".users_stories").effect("fade", "fast")



    if status.url.indexOf("tasks") > 0 && status.url.indexOf("add_new_comment") < 0
      $(".users_stories").fadeTo("fast", ".8", -> $(".users_stories").html(data.responseText).fadeTo("fast", "1"))
      $("#task_title, #task_assigned_to").val("")
      $("#task_title").focus()

focus_on_ready_on_create_task = () ->
  $("#task_title").focus().select()

$ ->
  create_sprint_toggle()
  filter_task_types()
#  hide_done_stories()
  delete_story()
  focus_on_ready_on_create_task()
  #  task_create_advanced_settings()
  project_id = $('body').data('projectId')

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

  $('span.estimates img').on 'click', (e) ->
    column_and_place = $(this).parents(".us_column").data("column")
    points = $(this).attr("rel")
    task_id = $(this).parents(".accordion-group").data("taskid")

    url_location = window.location.pathname


    $.ajax(
      url: "/projects/"+project_id+"/tasks/" + task_id + "/update_points"
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
    if url_location.indexOf("/task_boards")
      project_id = $("body").data("projectId")

      switch column_and_place
        when 'icebox' then update_icebox_in_us_page(project_id)
        when 'backlog' then update_backlog_in_us_page(project_id)
#        when 'my_work' then update_my_work_in_us_page(project_id)
        when 'current_work' then update_current_work_in_us_page(project_id)


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


  renderErorr = () ->
    if !$('form#new_project').find('#project_name').val()
      noty({text: 'Project name can\'t be blank' , type:'error'});
      return false
    else
      return true

  $('form#new_project').on('submit', renderErorr)