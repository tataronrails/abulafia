@TodoCtrl = ($scope) ->

  $scope.addTodo = ->
    $scope.todos.push { title: $scope.todoTitle, destroy: 0, edit: false }
    $scope.todoTitle = ''

  $scope.removeTodo = (index) ->
    if $scope.todos[index].id
      $scope.todos[index].destroy = 1
    else
      $scope.todos.splice(index, 1)

  $scope.editTodo = (index) ->
    $scope.todos[index].edit = true

  $scope.saveTodo = (index) ->
    $scope.todos[index].edit = false

  $scope.isVisible = (index) ->
    $scope.todos[index].destroy == 1

  false

TodoCtrl.$inject = ['$scope'];


intruction_select_ends_at = () ->
#  $("#task_end").hide()
  $("ul.dropdown-menu li a").click (e)->
    ends = $(this).data("finish")
    $("#task_end").val(ends.replace(/"/g,""))
    text = $(this).text()

#    console.log
    if $(this).data("default-text") == "Custom"

      $("#task_end").removeClass("h")
    else
      $("#task_end").addClass("h")

    if $(this).attr("data-anytime") == "true"
      text_span = $(".btn-group.other_toolbox button.active span#instruction_text")
      default_text = text_span.data("default_text")
      text_span.text(default_text)
      $("#task_task_type").val("")
      $(".btn-group.other_toolbox button.active").removeClass("btn-warning").removeClass("active")
    else
      $(".btn-group.other_toolbox button.active span#instruction_text").text(text)
    e.preventDefault()


task_type_detection = () ->
  get_type = $("#task_task_type").val()
  if(get_type)
    activate_me = $(".well.well-small").find("button[id="+get_type+"]")
    $(activate_me).addClass("active").addClass($(activate_me).data("class"))
  end_val = $("#task_end").val()

  if end_val.length > 0
    $(".btn-group.other_toolbox button span#instruction_text").text(end_val)
#    console.log $(activate_me)






$ ->

  $(document).ajaxSuccess (xhr, data, status) ->
    if status.url.indexOf("accept_to_start") > 0
      $("#accept_me").slideUp("fast").text(data.responseText).slideDown("fast")
    if status.url.indexOf("finish_work") > 0
      console.log data.responseText
      $(".accept_task").slideUp("fast").text(data.responseText).slideDown("fast")


  $("form textarea:first").focus().select() unless window.location.pathname.indexOf("/edit") > 0

  $("form:first")
    .bind "ajax:success", (xhr, data, status) ->
      $("form textarea").val("").focus()

      $("#comments_line").html(data.responseText)
      object = $(".alone_comment").first()
      $(object).hide()
      $(object).show("highlight", {}, 1300)
    .bind "ajax:error", (xhr, data, status) ->
      if status == "error"
        errors = $.parseJSON(data.responseText)
        $.each errors, (index, error) ->
          noty({text: "Error: " + error , type:'error'})

  $('form#new_task, form#new_comment').submit ->
    if $(@).find('textarea').val()
      return true
    else
      noty({text: "Field can't be blank" , type:'error'})
      return false




  task_type_detection() if $("#task_end").length > 0
  intruction_select_ends_at()
#  $('#task_start').datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true})

  $(".well.well-small button").click (e)->

    $(".well.well-small button").removeAttr("class").addClass("btn btn-small")

    $(this).addClass("active").addClass($(this).data("class"))

    if $(this).attr("id") == "0"
      $(".behavior_block").removeClass("h")
    else
      $(".behavior_block").addClass("h")


    val = $(this).attr("id")
    $("#task_task_type").val(val)

    e.preventDefault()


  $("#mention_logins").autocomplete source: availableTags

  availableTags = $("#mention_logins").data("logins")
#  $("#task_comment").triggeredAutocomplete
#    hidden: "#mention_logins"
#    source: availableTags