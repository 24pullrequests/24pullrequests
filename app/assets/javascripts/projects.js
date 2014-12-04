$(document).ready(function() {
  $('#filters input').each(function() {
    var self = $(this),
        label_text = self.val();

    self.iCheck({
      checkboxClass: 'icheckbox_line',
      radioClass: 'iradio_line',
      insert: label_text
    });

    if (self.attr('selected') === "selected") {
      self.iCheck('check');
      $("#clear_languages").removeClass('checked');
    }
  });

  $('[id^="clear_"]').each(function() {
    $(this).next().prepend($(this));
  });

  $('#noprojects').hide();

  $('#filters .iCheck-helper').on("click", function() {
    $('form#filters').submit();
    $(this).addClass('checked');
    $(this).parents('.form-group').children().first().removeClass('checked');
  });

  $('[id^="clear_"]').on("click", function() {
    $(this).parents(".check_boxes").iCheck('indeterminate');
    $(this).addClass('checked');
    $('form#filters').submit();
  });

});
