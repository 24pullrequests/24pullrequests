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
        $('#pull-requests-count').html $('.pull_request').length
        $("#spinner, #search_button").toggle()
        $(document).trigger('page:load')
        $('abbr.timeago').timeago()
