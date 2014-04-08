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

			this.setOpacity(0);
			this.$parent.append(this.$node);

			if (this.supportsTransforms()) {
				this.disableAnimations();

				// Center the overlay on the spot
				this.setScale(0.2);
				this.setCenter(spotCenter.x, spotCenter.y);

				this.enableAnimations();

				// Center the overlay over the map
				this.setOpacity(1);
				this.setScale(1);
				this.setCenter(parentCenter.x, parentCenter.y);
			} else {
				this.disableAnimations();

				this.setCenter(parentCenter.x, parentCenter.y);
				
				this.enableAnimations();

				this.setOpacity(1);
			}
		},

		remove: function() {
			var self         = this,
					top          = parseFloat(this.$node.css('top'), 10),
					finishRemove = function() {
						self.$node.remove();
						self.$parent = null;
					};

			this.enableAnimations();

			if (this.supportsAnimations()) {
				this.setOpacity(0);
				this.$node.css({ top: top + -50 + 'px' });

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

		setCenter: function(x, y) {
			var widthOffset  = this.$node.width() / 2,
					heightOffset = this.$node.height() / 2;

			this.$node.css({
				left: Math.round(x - widthOffset) + 'px',
				top:  Math.round(y - heightOffset) + 'px'
			});
		},

		setOpacity: function(value) {
			this.$node.css({ opacity: value });
		},

		setScale: function(value) {
			var property = Modernizr.prefixed('transform');

			this.$node.css(property, 'scale(' + value + ')');
		},

		supportsTransforms: function() {
			return Modernizr.csstransforms;
		},

		supportsAnimations: function() {
			return Modernizr.cssanimations;
		}
	};
})(jQuery);
