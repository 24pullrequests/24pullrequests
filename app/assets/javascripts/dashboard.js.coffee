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
        dropdown = $('#gift_pull_request_id')
        dropdown.empty()
        $('.pull_request[data-gifted="not_gifted"]').each((index, element) ->
          $element = $(element);
          option = $('<option/>').attr('value', $element.data('id')).text($element.data('dropdown-text'))
          dropdown.prepend(option)
        )
        $("#spinner, #search_button").toggle()
