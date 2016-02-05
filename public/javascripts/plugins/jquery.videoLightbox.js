(function($) {
  //Video lightbox
  $.fn.videoLightbox = function(options) {
    var opts = $.extend({}, $.fn.videoLightbox.defaults, options);

    return this.each(function() {
      var $this = $(this);

      // Support for the Metadata Plugin.
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;

      $this.bind('click', function(e) {
        var $videoLightbox = $('<div id="video-lightbox"></div>'),
            href           = $(this).attr('href');

        $videoLightbox
          .append(iframeCode(href, o))
          .appendTo('body');

        $videoLightbox.lightbox_me({
          onClose: function() {
            $videoLightbox.remove();
          }
        });

        e.preventDefault();
      });

    });

    // Source http://stackoverflow.com/a/8260383
    function parseYouTube(url){
      var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
      var match = url.match(regExp);
      return (match&&match[7].length==11)? match[7] : false;
    }

    function iframeCode(url, opts) {
      var youTubeVideoId = parseYouTube(url);

      if (youTubeVideoId) {
        var height = opts.width * 0.75;

        return '<iframe src="http://www.youtube.com/embed/' + youTubeVideoId + '" height="' + height + '" scrolling="no" width="' + opts.width + '" frameborder="0" allowfullscreen></iframe>';
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
