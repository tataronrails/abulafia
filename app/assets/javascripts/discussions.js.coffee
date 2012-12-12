$.ajaxSetup beforeSend: (xhr) -> xhr.setRequestHeader "Accept", "text/javascript"


discussions_menion = () ->
  $("#mention_logins").autocomplete source: availableTags


  availableTags = $("#mention_logins").data("logins")
  $("#discussion_comment").triggeredAutocomplete
    hidden: "#mention_logins"
    source: availableTags


$ ->
  discussions_menion()

  $("form textarea:first").focus().select()

  $("form:first")
    .bind "ajax:complete", (xhr, data, status) ->
      $("form textarea").val("").focus()

      $("#comments_line").html(data.responseText)
      object = $(".alone_comment").first()
      $(object).hide()
      $(object).show("highlight", {}, 1300)

