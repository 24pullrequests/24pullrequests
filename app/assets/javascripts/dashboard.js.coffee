$ ->
  $('a#fetch-pull-requests').click (event) ->
    event.preventDefault()

    $.ajax '/pull_request_download',
      dataType:'html',
      type: 'post',
      success: (data) ->
        $('#pull-requests').html(data)
