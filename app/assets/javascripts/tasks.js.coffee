# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


show_toolbox = () ->

#  $("#user_story_type").prop('checked', false)
#  $(".user_story_types").hide()

#  $("#user_story_type").change ->
#    $(".user_story_types").toggle()
#    us_toolbar = $(".user_story_types")

#    if $(us_toolbar).is(":visible")
#      $(".other_toolbox").hide()
#    else
#      $(".other_toolbox").show()





  get_type = $("#task_task_type").val()
  if(get_type)
    activate_me = $(".form-inline").find("button[id="+get_type+"]")
    $(activate_me).addClass("active")

#    $(".btn-group").hide()
#    $(activate_me).parents(".btn-group").show()

#    if get_type == '0' ||  get_type == '1' ||  get_type == '2'
#      $("#user_story_type").prop('checked', true)
#
#
#  if $(".user_story_types").is(":hidden")
#    $(".other_toolbox").show()
#  else
#    $(".user_story_types").show()




$ ->
  show_toolbox()


  $(".form-inline button").click (e)->
    $(".form-inline button").removeClass("active")
    $(this).addClass("active")
    val = $(this).attr("id")
    console.log(val)
    $("#task_task_type").val(val)

    e.preventDefault()


  $("#mention_logins").autocomplete source: availableTags

  availableTags = $("#mention_logins").data("logins")
  $("#task_comment").triggeredAutocomplete
    hidden: "#mention_logins"
    source: availableTags