# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggle_add_note_to_user = () ->
  $("a.add_note_to_user_toggle").click ->
    $(".form_to_add_note").toggleClass("h")


toggle_create_user_form = () ->
  $("a.create_user_link").click ->
    $(".well.well-large").toggleClass("h")


add_comments_to_user = () ->
  $("form#add_new_comment_to_contact")
    .bind "ajax:complete", (xhr, data, status) ->
      $("form textarea").val("").focus()

      $("#comments_line").html(data.responseText)
      object = $(".alone_comment").first()
      $(object).hide()
      $(object).show("highlight", {}, 1300)

$ ->
  toggle_add_note_to_user()
  add_comments_to_user()
  toggle_create_user_form()

  $(".toggle_create_strike").click (e) ->
    e.preventDefault()
    $(".new_strike").toggle()