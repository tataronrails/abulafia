$("form#new_user:not(.virtual-user)").submit ->
  if !$(@).find('#user_email').val() || !$(@).find('#user_password').val()
    noty({text: "Username and password can't be blank", type: 'error'})
    return false
  else
    return true