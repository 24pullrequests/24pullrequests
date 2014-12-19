$ ->
  $(".js-emoji").each ->
    $(@).html(emojione.toImage($(@).text()))
