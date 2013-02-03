# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


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






jQuery ->
  $("#btn-types button.active").addClass($("#btn-types button.active").data("class"))

  # (tasks/_form) Выбор типа задачи
  $buttons = $("#btn-types button")
  $buttons.click (e) ->
    $this = $(this)

    # Изменение цвета кнопок при залипании.
    $buttons.removeAttr("class").addClass("btn btn-small")
    $this.addClass($this.data("class"))

    # Показать поле Behavior, если выбран тип feature
    if $this.attr("id") == "feature"
      $(".behavior_block").show('500')
    else
      $(".behavior_block").hide('500')

    # Задаем поле type
    $('#task_type').val(jQuery.camelCase("-"+$this.attr('id')+"Task"))

    e.preventDefault()

  # (tasks/_form) - Поле end_at
  $dropdown_items = $('#other-toolbox ul li a')
  $dropdown_items.click (e) ->
    $this = $(this)

    # Изменение текста в зависимости от элемента
    $str = "<i class='icon-calendar'></i> "
    $str+= $this.text()
    $str+= " <span class='caret'></span>"
    $('#other-toolbox #date-dropdown').html($str)

    # Если выбран custom, то показываем поле end_at
    $temp = $('#other-toolbox').children('div')
    if $this.attr("id") == "custom-date"
      $temp.addClass('input-prepend').removeClass('btn-group')
      $("#prependedDropdownButton").show 'hidelight'
    else
      $("#prependedDropdownButton").hide 'hidelight', ->
        $temp.addClass('btn-group').removeClass('input-prepend')

    # Задаем поле end_at
    $('#other-toolbox .date-field#prependedDropdownButton').val($this.data('finish'))

    e.preventDefault()





  $(document).ajaxComplete (xhr, data, status) ->
    if status.url.indexOf("accept_to_start") > 0
      $("#accept_me").slideUp("fast").text(data.responseText).slideDown("fast")
    if status.url.indexOf("finish_work") > 0
      console.log data.responseText
      $(".accept_task").slideUp("fast").text(data.responseText).slideDown("fast")


  $("form textarea:first").focus().select() unless window.location.pathname.indexOf("/edit") > 0

  $("form:first")
    .bind "ajax:complete", (xhr, data, status) ->
      $("form textarea").val("").focus()

      $("#comments_line").html(data.responseText)
      object = $(".alone_comment").first()
      $(object).hide()
      $(object).show("highlight", {}, 1300)



  task_type_detection() if $("#task_end").length > 0
  intruction_select_ends_at()
#  $('#task_start').datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true})

  $("#mention_logins").autocomplete source: availableTags

  availableTags = $("#mention_logins").data("logins")
#  $("#task_comment").triggeredAutocomplete
#    hidden: "#mention_logins"
#    source: availableTags