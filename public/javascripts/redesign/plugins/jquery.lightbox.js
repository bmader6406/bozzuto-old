(function($) {
  $.fn.lightbox = function(opts) {
    opts = $.extend({
      centered:   true,
      overlayCSS: {
        background: '#000000',
        opacity:    .50
      }
    }, opts);

    this.lightbox_me(opts);

    return this;
  };
})(jQuery);
