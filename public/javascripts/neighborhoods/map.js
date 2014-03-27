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
      var self = this;

      this.$toggleLink.bind('click', function(e) {
        e.preventDefault();

        self.toggleView();
      });
    },

    places: function() {
      if (!this._places) {
        var nodes = this.$map.find('.nh-map-location');

        this._places = $.map(nodes, function(node) {
          return new bozzuto.Neighborhoods.Place(node);
        });
      }

      return this._places;
    },

    memberships: function() {
      if (!this._memberships) {
        var nodes = this.$map.find('.nh-map-membership');

        this._memberships = $.map(nodes, function(node) {
          return new bozzuto.Neighborhoods.Membership(node);
        });
      }

      return this._memberships;
    },

    render: function() {
      // Create the map
      this.map = new google.maps.Map(this.$canvas[0], {
        navigationControlOptions: {
          style: google.maps.NavigationControlStyle.SMALL
        },
        mapTypeControl: false,
        zoom:           9,
        center:         this.initialPoint()
      });

      // Add the points
      this.switchToNeighborhoodsView();
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
      this.removePoints(this.places());
      this.drawPoints(this.memberships());

      this.currentView = 'communities';
      this.$toggleLink.text('Show All Neighborhoods On Map');
    },

    switchToNeighborhoodsView: function() {
      this.removePoints(this.memberships());
      this.drawPoints(this.places());

      this.currentView = 'neighborhoods';
      this.$toggleLink.text('Show All Communities On Map');
    },

    removePoints: function(points) {
      $.each(points, function(_, point) {
        point.marker().setMap(null);
      });
    },

    drawPoints: function(points) {
      var self = this;

      if (points.length == 0) {
        // Center map at the initial point
        this.map.setCenter(this.initialPoint());
        this.map.setZoom(8);
      } else if (points.length == 1) {
        // Center map at the only point
        this.map.setCenter(points[0].toLatLng());
        this.map.setZoom(11);
      } else {
        // Fit the map to the data points
        this.map.fitBounds(this.bounds(points));
      }

      // Add the markers
      $.each(points, function(_, point) {
        point.marker().setMap(self.map)
      });
    }
  };
})(jQuery);
