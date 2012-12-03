$ ->
  projects = $('#projects').clone()

  languages = []
  $('#languages a').click (e) ->
    clicked_language = $(this).data().language

    return false unless clicked_language?

    unless event.ctrlKey or event.metaKey
      languages = [$(this).data().language]
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

    else
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.project'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
    return false
