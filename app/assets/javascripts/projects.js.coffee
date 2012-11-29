# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $(".add_project_block a").click (e) ->
    $(".add_new_project_field").slideToggle("fast", -> $("#project_name").focus().select())
    e.preventDefault();

  $("#collapseOne").on "shown", ->
    $("#discussion_title").focus().select()

  if location.hash == "#comments"
    $(".accordion-group.existed_discussions #collapseTwo").collapse('show')