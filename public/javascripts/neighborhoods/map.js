(function($) {
  bozzuto.Neighborhoods.Map = function(map) {
    this.$map         = $(map);
    this.$canvas      = this.$map.find('.nh-map-canvas');
    this.currentView  = 'neighborhoods';
    this.$toggleLink  = this.$map.find('.nh-map-controls-show-all');

    this.initializeToggleSwitch();
  };

  bozzuto.Neighborhoods.Map.prototype = {
    initialPoint: function() {
      // Washington, DC
      return new google.maps.LatLng(38.8976, -77.0364);
    },

    initializeToggleSwitch: function() {
      var anyNeighborhoods = this.neighborhoods().length > 0,
          anyCommunities   = this.communities().length > 0;


      if (anyNeighborhoods && anyCommunities) {
        var self = this;

        this.$toggleLink.bind('click', function(e) {
          e.preventDefault();

          self.toggleView();
        });
      } else {
        this.$toggleLink.remove();
      }
    },

    neighborhoods: function() {
      if (!this._neighborhoods) {
        var self  = this,
            nodes = this.$map.find('.nh-map-neighborhood');

        this._neighborhoods = $.map(nodes, function(node) {
          return new bozzuto.Neighborhoods.Neighborhood(self, node);
        });
      }

      return this._neighborhoods;
    },

    communities: function() {
      if (!this._communities) {
        var self  = this,
            nodes = this.$map.find('.nh-map-community');

        this._communities = $.map(nodes, function(node) {
          return new bozzuto.Neighborhoods.Community(self, node);
        });
      }

      return this._communities;
    },

    render: function() {
      if (this.gMap) {
        return;
      }

      // Create the map
      this.gMap = new google.maps.Map(this.$canvas[0], {
        navigationControlOptions: {
          style: google.maps.NavigationControlStyle.SMALL
        },
        scrollwheel:    false,
        mapTypeControl: false,
        zoom:           9,
        center:         this.initialPoint()
      });

      this.setupConversion();

      // Add the points
      if (this.neighborhoods().length > 0) {
        this.switchToNeighborhoodsView();
      } else {
        this.switchToCommunityView();
      }
    },

    bounds: function(points) {
      var first = points[0],
          rest  = points.slice(1);

      var bounds = new google.maps.LatLngBounds(first.toLatLng(), first.toLatLng());

      $.each(rest, function(_, place) {
        bounds.extend(place.toLatLng(), place.toLatLng());
      });

      return bounds;
    },

    toggleView: function() {
      if (this.currentView == 'neighborhoods') {
        this.switchToCommunityView();
      } else {
        this.switchToNeighborhoodsView();
      }
    },

    switchToCommunityView: function() {
      this.removePoints(this.neighborhoods());
      this.drawPoints(this.communities());

      this.currentView = 'communities';
      this.$toggleLink.text('Show All Neighborhoods On Map');
    },

    switchToNeighborhoodsView: function() {
      this.removePoints(this.communities());
      this.drawPoints(this.neighborhoods());

      this.currentView = 'neighborhoods';
      this.$toggleLink.text('Show All Communities On Map');
    },

    removePoints: function(points) {
      $.each(points, function(_, point) {
        point.setMap(null);
      });
    },

    drawPoints: function(points) {
      var self = this;

      if (points.length == 0) {
        // Center map at the initial point
        this.gMap.setCenter(this.initialPoint());
        this.gMap.setZoom(13);
      } else if (points.length == 1) {
        var point = points[0];

        // Center map at the only point
        this.gMap.setCenter(point.toLatLng());
        this.gMap.setZoom(this.zoomForPoint(point));
      } else {
        // Fit the map to the data points
        this.gMap.fitBounds(this.bounds(points));
      }

      // Add the markers
      $.each(points, function(_, point) {
        point.setMap(self.gMap)
      });
    },

    zoomForPoint: function(point) {
      switch (point.category) {
        case 'Metro':
        case 'Area':
          return 11;
        case 'Neighborhood':
          return 13;
        default:
          return 15;
      }
    },

    showOverlay: function(spot) {
      if (this.$overlay) {
        return;
      }

      this.$overlay = $(spot.overlayContent())

      this.addBlocker();
      this.$map.append(this.$overlay);

      var position = this.latLngToPixel(spot.toLatLng());

      var width  = this.$overlay.width(),
          height = this.$overlay.height();

      this.$overlay.css({
        marginTop:  -(height / 2) + 'px',
        marginLeft: -(width / 2) + 'px'
      });
    },

    hideOverlay: function() {
      if (!this.$overlay) {
        return;
      }

      this.removeBlocker();
      this.$overlay.remove();
      this.$overlay = null;
    },

    addBlocker: function() {
      if (this.$blocker) {
        return;
      }

      this.$blocker = $('<div class="nh-map-blocker"></div>');
      this.$map.append(this.$blocker);

      var self = this;

      this.$blocker.bind('click', function() {
        self.hideOverlay();
      });
    },

    removeBlocker: function() {
      if (!this.$blocker) {
        return;
      }

      this.$blocker.remove();
      this.$blocker = null;
    },

    latLngToPixel: function(position) {
      return this._conversionOverlay.getProjection().fromLatLngToContainerPixel(position);
    },

    setupConversion: function() {
      if (!this._conversionOverlay) {
        var overlay = new google.maps.OverlayView();

        overlay.draw = function() {};
        overlay.setMap(this.gMap);

        this._conversionOverlay = overlay;
      }
    }
  };
})(jQuery);
