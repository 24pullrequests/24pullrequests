$(document).ready(function () {
  const scrollToTopButton = $("#btn-back-to-top");

  $(window).scroll(function () {
    scrollFunction();
  });

  function scrollFunction() {
    if ($(document).scrollTop() > 500) {
      scrollToTopButton.css("display", "block");
    } else {
      scrollToTopButton.css("display", "none");
    }
  }

  scrollToTopButton.click(function () {
    $("body, html").scrollTop(0);
  });
});
