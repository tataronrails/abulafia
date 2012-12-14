# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#mention_logins").autocomplete source: availableTags


  availableTags = $("#mention_logins").data("logins")
  $("#task_comment").triggeredAutocomplete
    hidden: "#mention_logins"
    source: availableTags