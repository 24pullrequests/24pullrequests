$ ->
  $(".js-twemoji").each ->
    $(@).html(twemoji.parse($(@).html()))
