(function($) {
  //Video lightbox
  $.fn.videoLightbox = function(options) {
    var opts = $.extend({}, $.fn.videoLightbox.defaults, options);

    return this.each(function() {
      var $this = $(this);

      // Support for the Metadata Plugin.
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;

      $this.bind('click', function(e) {
        e.preventDefault();

        var $videoLightbox = $('<div id="video-lightbox" class="modal"></div>'),
            href           = $(this).attr('href');

        $videoLightbox
          .append(iframeCode(href, o))
          .appendTo('body');

        $videoLightbox.lightbox({ destroyOnClose: true });
      });

    });

    function iframeCode(url, opts) {
      var isYouTubeVideo = url.match(/youtube\.com/),
          youTubeMatches = url.match(/(?:(?:v=)|(?:embed\/))([_A-Za-z0-9]+)/);

      if (isYouTubeVideo && youTubeMatches && youTubeMatches.length == 2) {
        var height = opts.width * 0.75;

        return '<iframe src="http://www.youtube.com/embed/' + youTubeMatches[1] + '" height="' + height + '" scrolling="no" width="' + opts.width + '" frameborder="0" allowfullscreen></iframe>';
      } else {
        return '<iframe src="' + url + '" height="' + opts.height + '" scrolling="no" width="' + opts.width + '"></iframe>';
      }
    }
  };

  // default options
  $.fn.videoLightbox.defaults = {
    height: 372,
    width: 700
  };
})(jQuery);
