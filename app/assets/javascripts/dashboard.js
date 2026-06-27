$(function() {
  $("#spinner").hide();

  $("a#fetch-pull-requests").click(function(event) {
    event.preventDefault();
    $("#spinner, #search_button").toggle();

    $.ajax("/pull_request_download", {
      dataType: "html",
      type: "post",

      success: function(data) {
        $("#pull-requests").html(data);
        $("#pull-requests-count").html($(".contribution").length);
        $("#spinner, #search_button").toggle();
        $(document).trigger("page:load");
        $("abbr.timeago").timeago();
      }
    });
  });
});
