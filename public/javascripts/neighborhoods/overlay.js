(function($) {
  bozzuto.Neighborhoods.Overlay = function(map, spot) {
    this.map               = map;
    this.spot              = spot;
    this.animationDuration = 300;
    this.$node             = $(this.spot.overlayContent());
  };

  bozzuto.Neighborhoods.Overlay.prototype = {
    setParent: function(parent) {
      this.$parent = $(parent);

      var parentCenter = this.map.center(),
          spotCenter   = this.map.latLngToPixel(this.spot.toLatLng());

      this.$parent.append(this.$node);

      if (this.supportsTransforms()) {
        this.disableAnimations();

        // Position the center of the overlay at 0, 0.
        // This is so we can translate using center positions
        this.setCenter({ x: 0, y: 0 });

        // Center the overlay on the spot
        this.setOpacity(0);
        this.transform(spotCenter.x, spotCenter.y, 0.2);

        this.redraw();

        this.enableAnimations();

        // After the transition finishes, remove the transform and
        // set the position to the center of the map. This is to:
        //
        // 1. get rid of the fuzziness caused by transforms
        // 2. prep for using a transform on close
        var self = this;

        this.$node.one($.transitionEndEvent, function() {
          self.disableAnimations();

          self.removeTransform();
          self.setCenter(parentCenter);
        });

        // Center the overlay over the map
        this.setOpacity(1);
        this.transform(parentCenter.x, parentCenter.y, 1);
      } else {
        this.setCenter(parentCenter);
      }
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
      var widthOffset  = this.$node.width() / 2,
          heightOffset = this.$node.height() / 2;

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
