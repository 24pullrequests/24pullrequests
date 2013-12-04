$ ->
  projects = $('#projects').clone()
  $('#noprojects').hide()

  languages = []
  $('#languages a').click (e) ->
    clicked_language = $(this).data().language

    unless clicked_language?
      fetchProjects()
      resetLanguage()
      return false

    unless e.ctrlKey or e.metaKey
      languages = [].concat(clicked_language)
    else
      unless clicked_language in languages
        languages.push clicked_language
      else
        languages = (language for language in languages when language != clicked_language)

    unless languages.length > 0
      resetLanguage()
    else
      $('#languages li')
        .addClass('disabled')
        .find($.map(languages, (l) -> "a[data-language='#{l}']").join(','))
        .parent('li')
        .removeClass('disabled')

      filterProjects(languages.join(','))
    return false

  fetchProjects = ->
    $.ajax
      url: '/projects'
      dataType: 'script'

  filterProjects = (languages) ->
    $.ajax
      url: '/projects/filter?languages='+languages
      dataType: 'script'

  resetLanguage = ->
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.span12'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
