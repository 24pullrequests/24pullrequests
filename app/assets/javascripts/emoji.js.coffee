window.emojify = ->
  $(".js-emoji").each ->
    $(@).html(emojione.toImage($(@).text()))

$ -> emojify()
