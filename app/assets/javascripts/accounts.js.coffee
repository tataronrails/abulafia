# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('form#new_user').submit ->
  if !$(@).find('#user_email').val() || !$(@).find('#user_password').val()
    noty({text: "Username and password can't be blank", type: 'error'})
    return false
  else
    return true
