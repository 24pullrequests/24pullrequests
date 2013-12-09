$(document).ready(function(){
  $('input').each(function(){
    var self = $(this),
    label_text = self.val();

    self.iCheck({
      checkboxClass: 'icheckbox_line',
      radioClass: 'iradio_line',
      insert: '<div class="icheck_line-icon"></div>' + label_text
    });
  });
});
