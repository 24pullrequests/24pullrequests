$ ->
  projects = $('#projects').clone()
  
  $('#languages a').click ->
    language = $(this).data().language
    $('#noprojects').hide()
    if language?
      $('#languages li').addClass('disabled')
      $(this).parents('li').removeClass('disabled')
      $('#projects').quicksand $(projects).find(".#{$(this).data().language}"), duration: 0, ->
        if $('#projects .project:visible').length == 0
          $('#noprojects').show()
      
    else
      $('#languages li').removeClass('disabled')
      $('#projects').html(projects.find('.project'))
      projects = $('#projects').clone()
      $('#projects').css('height', 'auto')
    return false
