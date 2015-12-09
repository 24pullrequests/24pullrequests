$(document).on('ready', function(){
  var text       = 'Fill out the form from the github repo',
      button     = $('<a href="#">' + text + '</a>'),
      form       = $('form#new_project[action="/projects"]'),
      github_url = form.find('#project_github_url');

  github_url.after(button);

  github_url.on('keydown', function(e) {
    if (e.keyCode == 13 && $.trim($(this).val()) !== '') {
      e.preventDefault();
      button.trigger('click');
    }
  });

  button.on('click', function(e){
    e.preventDefault();

    button.text('Loading...');

    var req = $.ajax({
      url: '/projects/autofill',
      method: 'GET',
      dataType: 'JSON',
      data: {
        repo: github_url.val()
      }
    });

    req.success(function(data){
      github_url.val(data.repository.html_url);
      form.find('#project_name').val(data.repository.name);
      form.find('#project_description').val(data.repository.description);
      form.find('#project_main_language').val(data.repository.language);

      // This version of typeahead has been deprecated in
      // more recent versions of bootrap
      // So to set the value here, I have to re-initialize
      // the plugin again afer setting the value!
      languageAutocomplete();

      if (data.labels) {
        form.find('.project_labels input').prop('checked', false);

        form.find('.project_labels label').each(function(){
          if ($.inArray($(this).text(), data.labels) > 0) {
            $(this).find('input').prop('checked', true);
          }
        })
      }

      if (data.repo_exists) {
        alert('Repository already suggested');
      }
    });

    req.fail(function(res){
      if (res.responseJSON && res.responseJSON.message) {
        alert(res.responseJSON.message);
      }
    });

    req.complete(function(data){
      button.text(text);
    });
  });
});
