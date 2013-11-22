(function($) {
  $.fn.lightbox = function(opts) {
    opts = $.extend({
      centered:   true,
      overlayCSS: {
        background: '#000000',
        opacity:    .50
      }
    }, opts);

		if (this.find('a.modal-close').length == 0) {
			this.append($('<a href="#" class="modal-close close">Close</a>'));
		}

    this.lightbox_me(opts);

    return this;
  };
})(jQuery);
