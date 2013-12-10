$(document).ready(function(){
  $('input').each(function(){
    var self = $(this);
    label_text = self.val();
    selected = self.attr('selected');

    self.iCheck({
      checkboxClass: 'icheckbox_line',
      radioClass: 'iradio_line',
      insert: label_text
    });

    if (selected == "selected") {
      self.iCheck('check');
    }
  });


  $('.project .iCheck-helper').on("click", function() {
    if ($(this).parent().text() == "All Languages") {
      $(".check_boxes").iCheck('indeterminate');
    }
    $('form.project').submit();
  });
});
