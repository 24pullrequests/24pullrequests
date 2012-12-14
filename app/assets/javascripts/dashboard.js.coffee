$ ->
  $("#spinner").hide()
  $('a#fetch-pull-requests').click (event) ->
    event.preventDefault()
    $("#spinner, #search_button").toggle()


    $.ajax '/pull_request_download',
      dataType:'html',
      type: 'post',

      success: (data) ->
        $('#pull-requests').html(data)
        $("#spinner, #search_button").toggle()
