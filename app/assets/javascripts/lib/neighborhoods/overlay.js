(function($) {
  bozzuto.Neighborhoods.Overlay = function(map, spot) {
    this.map               = map;
    this.spot              = spot;
    this.animationDuration = 300;
    this.$node             = $(this.spot.overlayContent());
    this.$close            = this.$node.find('.nh-map-overlay-close');

    var self = this;

    this.$close.bind('click', function(e) {
      e.preventDefault();

      self.map.closeOverlay();
    });
  };

  bozzuto.Neighborhoods.Overlay.prototype = {
    setParent: function(parent) {
      this.$parent = $(parent);

      var parentCenter = this.map.center(),
          spotCenter   = this.map.latLngToPixel(this.spot.toLatLng());

      this.$parent.append(this.$node);

      this.setCenter(parentCenter);
    },

    remove: function() {
      var self         = this,
          top          = parseFloat(this.$node.css('top'), 10),
          finishRemove = function() {
            self.$node.remove();
            self.$parent = null;
          };

      if (this.supportsTransforms()) {
        this.enableAnimations();

        this.setOpacity(0);
        this.transform(0, 65, 1, (Math.random() * 3 - 1.5));

        setTimeout(finishRemove, this.animationDuration);
      } else {
        finishRemove();
      }
    },

    enableAnimations: function() {
      this.$node.addClass('animated');
    },

    disableAnimations: function() {
      this.$node.removeClass('animated');
    },

    redraw: function() {
      this.$node.hide();
      this.$node.show();
    },

    setCenter: function(point) {
      var widthOffset  = this.$node.outerWidth() / 2,
          heightOffset = this.$node.outerHeight() / 2;

      this.$node.css({
        left: (point.x - widthOffset) + 'px',
        top:  (point.y - heightOffset) + 'px'
      });
    },

    setOpacity: function(value) {
      this.$node.css({ opacity: value });
    },

    supportsTransforms: function() {
      return Modernizr.csstransforms && $.transitionEndEvent !== null;
    },

    transform: function(x, y, scale, rotate) {
      rotate = rotate || 0;

      var property = Modernizr.prefixed('transform');

      this.$node.css(property, 'translate(' + x + 'px, ' + y + 'px) ' +
                               'scale(' + scale + ') ' +
                               'rotate(' + rotate + 'deg) ' +
                               'translateZ(0)');
    },

    removeTransform: function() {
      var property = Modernizr.prefixed('transform');

      this.$node.css(property, null);
    }
  };
})(jQuery);
