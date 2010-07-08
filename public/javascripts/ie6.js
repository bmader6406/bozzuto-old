(function($) {

  $(function() {
    // hover fix for IE6
    var hoverFix = ["#main-nav li"];
    $(hoverFix.join(", ")).hoverFix();

    // PNG fix
    var pngFix = [
      ".home #news h2",
      ".home #finder a",
      ".social-updates .byline",
      ".community #slideshow a.prev",
      ".community #slideshow a.next",
      ".community #slideshow p.watch-video a",
			".about #aside h3 a",
			".apartments .slideshow-navigation a",
			".slideshow-navigation a",
			".project #main-content .content .main-content ul.project-updates li div p.info-link a",
			".project #main-content .content .main-content ul.project-updates li div div.info-overlay",
			".property #slideshow .overlay"
    ];
    DD_belatedPNG.fix(pngFix.join(", "));

    // IE6 bg image fix
    try {
      document.execCommand("BackgroundImageCache", false, true);
    } catch(err) {}
  });


  $.fn.hoverFix = function() {
    if (document.all) {
      $(this).hover(function() {
        $(this).addClass("hover");
      }, function() {
        $(this).removeClass("hover");
      });
    }
    return $(this);
  };


})(jQuery);

