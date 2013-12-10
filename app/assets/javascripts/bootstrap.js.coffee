jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("[rel=tooltip]").tooltip()

  $('#presents a:first').tab('show')

  $("#presents a").click (e) ->
    e.preventDefault()
    $(this).tab "show"
