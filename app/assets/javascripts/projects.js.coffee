$ ->
  projects = $('#projects').clone()

  languages = []
  $('#languages a').click (e) ->
    clicked_language = $(this).data().language

    unless clicked_language?
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.project'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
      return

    unless e.ctrlKey or e.metaKey
      languages = [].concat(clicked_language)
    else
      unless clicked_language in languages
        languages.push clicked_language
      else
        languages = (language for language in languages when language != clicked_language)

    $('#noprojects').hide()

    if languages.length > 0
      $('#languages li')
        .addClass('disabled')
        .find($.map(languages, (l) -> "a[data-language=#{l}]").join(','))
        .parent('li')
        .removeClass('disabled')

      $('#projects').quicksand $(projects).find(".#{languages.join(', .')}"), duration: 0, ->
        if $('#projects .project:visible').length == 0
          $('#noprojects').show()
