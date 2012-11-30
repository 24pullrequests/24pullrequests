$ ->
  projects = $('#projects').clone()
  
  $('#languages a').click ->
    language = $(this).data().language
    if language?
      $('#languages li').addClass('disabled')
      $(this).parents('li').removeClass('disabled')
      $('#projects').quicksand($(projects).find(".#{$(this).data().language}"))
    else
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.project'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
    return false
