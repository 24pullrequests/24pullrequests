$ ->
  projects = $('#projects').clone()

  $('#languages a').click (e) ->
    language = $(this).data().language

    $('#noprojects').hide()

    if language?
      language = [language] unless $.isArray(language)

      $('#languages li')
        .addClass('disabled')
        .find($.map(language, (l) -> "a[data-language=#{l}]").join(','))
        .add(this)
        .parent('li')
        .removeClass('disabled')

      $('#projects').quicksand $(projects).find(".#{language.join(', .')}"), duration: 0, ->
        if $('#projects .project:visible').length == 0
          $('#noprojects').show()

    else
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.project'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
    return false
