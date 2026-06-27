window.languageAutocomplete = function() {
  var $typeahead = $("[data-provide=typeahead]");

  if (!$typeahead.length) {
    return false;
  }

  var projectLanguages = $typeahead.data("source");

  $typeahead.typeahead({
    local: projectLanguages
  });
};

jQuery.timeago.settings.allowFuture = true;

jQuery(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("[rel=tooltip]").tooltip();

  $("#presents a:first").tab("show");

  $("#presents a").click(function(e) {
    e.preventDefault();
    $(this).tab("show");

    languageAutocomplete();
  });
});

$(document).on("ready page:load", function() {
  Emojify.replace(".js-emoji");
});
