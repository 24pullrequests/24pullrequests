$(document).ready(function () {
  const mybutton = $("#btn-back-to-top");

  $(window).scroll(function () {
    scrollFunction();
  });

  function scrollFunction() {
    if ($(document).scrollTop() > 500) {
      mybutton.css("display", "block");
    } else {
      mybutton.css("display", "none");
    }
  }

  mybutton.click(function () {
    $("body, html").scrollTop(0);
  });
});
