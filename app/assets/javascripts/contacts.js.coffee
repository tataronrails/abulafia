# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



$ ->
  alert 1
  $(".toggle_create_strike").click (e) ->
    e.preventDefault()
    $(".new_strike").toggle()