(function($) {
  $(function() {
    bozzuto.Neighborhoods.init();
  });

  bozzuto.Neighborhoods = {
    init: function() {
      this.map();
    },

    map: function() {
      var $mapCanvas = $('.nh-map-canvas');

      if ($mapCanvas.length > 0) {
        var map = new bozzuto.Neighborhoods.Map($('.nh-map-canvas'));

        map.render();
      }
    },

    Place: function(node) {
      this.json             = $.parseJSON($(node).attr('data-jmapping'));
      this.id               = this.json['id'];
      this.category         = this.json['category'];
      this.name             = this.json['name'];
      this.communitiesCount = this.json['apartment_communities_count'];
      this.latitude         = this.json['point']['lat'];
      this.longitude        = this.json['point']['lng'];

      return this;
    },

    Map: function(mapCanvas) {
      this.initialPoint = new google.maps.LatLng(38.8976, -77.0364); // Washington, DC

      this.$mapCanvas = $(mapCanvas);

      this.places = $.map($('.nh-map-location'), function(place) {
        return new bozzuto.Neighborhoods.Place(place);
      });

      return this;
    }
  };

  bozzuto.Neighborhoods.Place.prototype = {
    toLatLng: function() {
      return new google.maps.LatLng(this.latitude, this.longitude);
    },

    toMarker: function() {
      switch (this.category) {
        case 'Metro':
        case 'Area':
        case 'Neighborhood':
          return this.placeMarker();
        default:
          return this.communityMarker();
      }
    },

    placeMarker: function() {
      var labelClass = 'nh-map-marker-cty',
          count      = this.communitiesCount;

      // Set class for small text size if count has more than 2 digits
      if (count > 99) {
        labelClass += ' nh-map-marker-cty-small';
      }
      
      return new MarkerWithLabel({
        position:     this.toLatLng(),
        title:        this.name,
        labelContent: count.toString(),
        labelAnchor:  new google.maps.Point(20, 20),
        labelClass:   labelClass,
        icon: {
          url:    '/images/neighborhoods/nh-marker.png',
          size:   new google.maps.Size(40, 40),
          anchor: new google.maps.Point(20, 20)
        }
      });
    },

    communityMarker: function() {
      return new google.maps.Marker({
        position: this.toLatLng(),
        icon: {
          url:  '/images/neighborhoods/cty-marker.png',
          size: new google.maps.Size(40, 40)
        }
      });
    }
  };


  bozzuto.Neighborhoods.Map.prototype = {
    render: function() {
      var self = this;

      // Create the map
      this.map = new google.maps.Map(this.$mapCanvas[0], {
        navigationControlOptions: {
          style: google.maps.NavigationControlStyle.SMALL
        },
        mapTypeControl: false,
        zoom:           9,
        center:         this.initialPoint
      });

      // Fit the map to the data points
      this.map.fitBounds(this.bounds());

      // Set the zoom to a reasonable value, if there's only one community
      if (this.places.length == 1) {
        var listener = google.maps.event.addListener(this.map, "idle", function() { 
          self.map.setZoom(11);

          google.maps.event.removeListener(listener); 
        });
      }

      // Add the markers
      $.each(this.places, function(_, place) {
        var marker = place.toMarker();

        marker.setMap(self.map)
      });
    },

    bounds: function() {
      var first = this.places[0],
          rest  = this.places.slice(1);

      var bounds = new google.maps.LatLngBounds(first.toLatLng(), first.toLatLng());

      $.each(rest, function(_, place) {
        bounds.extend(place.toLatLng(), place.toLatLng());
      });

      return bounds;
    }
  };
})(jQuery);
