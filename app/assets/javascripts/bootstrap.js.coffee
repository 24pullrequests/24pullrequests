window.languageAutocomplete = ->
  return false if !$("[data-provide=typeahead]").length

  projectLanguages = $("[data-provide=typeahead]").data "source"

  $("[data-provide=typeahead]").typeahead
    name: $(this).attr "name"
    local: projectLanguages

jQuery.timeago.settings.allowFuture = true;

jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("[rel=tooltip]").tooltip()

  $('#presents a:first').tab('show')

  $("#presents a").click (e) ->
    e.preventDefault()
    $(this).tab "show"

    languageAutocomplete()

$(document).on 'ready page:load', ->
  Emojify.replace '.js-emoji'
