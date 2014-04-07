(function($) {
  // Spot parent object
  bozzuto.Neighborhoods.Spot = function(node) {
    this.infoWindowContent = $(node).find('.nh-map-info-window')[0].outerHTML;
    this.json              = $.parseJSON($(node).attr('data-jmapping'));
    this.id                = this.json['id'];
    this.category          = this.json['category'];
    this.name              = this.json['name'];
    this.communitiesCount  = this.json['apartment_communities_count'];
    this.latitude          = this.json['point']['lat'];
    this.longitude         = this.json['point']['lng'];
  };

  bozzuto.Neighborhoods.Spot.prototype = {
    toLatLng: function() {
      return new google.maps.LatLng(this.latitude, this.longitude);
    },

    setMap: function(map) {
      this.clearEventListeners();

      this.marker().setMap(map);

      this.setEventListeners();
    },

    clearEventListeners: function() {
      google.maps.event.clearInstanceListeners(this.marker());
    },

    setEventListeners: function() {
      var self   = this,
          marker = this.marker(),
          map    = marker.getMap();

      if (!map) {
        return;
      }

      // Open info window on mouseover
      google.maps.event.addListener(marker, 'mouseover', function() {
        self.infoWindow().open(map, marker);
      });

      // Close info window on mouseout
      google.maps.event.addListener(this.marker(), 'mouseout', function() {
        self.infoWindow().close();
      });

      // Remove the close button
      google.maps.event.addListener(this.infoWindow(), 'domready', function() {
        try {
          var $content   = $(this.D.getContentNode()),
              $container = $content.parent().parent();

          // Only remove if the close button is still present. There's no class
          // on the node, so we have to find it this way.
          if ($container.children().length == 3) {
            $container.children().last().remove();
          }
        } catch (err) {}
      });
    },

    infoWindow: function() {
      if (!this._infoWindow) {
        this._infoWindow = new google.maps.InfoWindow({
          disableAutoPan: true,
          content:        this.infoWindowContent
        });
      }

      return this._infoWindow;
    }
  };

  // Neighborhood spot
  bozzuto.Neighborhoods.Neighborhood = function(node) {
    bozzuto.Neighborhoods.Spot.call(this, [node]);
  };

  bozzuto.Neighborhoods.Neighborhood.prototype = Object.create(bozzuto.Neighborhoods.Spot.prototype);
  bozzuto.Neighborhoods.Neighborhood.prototype.constructor = bozzuto.Neighborhoods.Neighborhood;

  bozzuto.Neighborhoods.Neighborhood.prototype.marker = function() {
    if (!this._marker) {
      var labelClass = 'nh-map-marker-cty',
          count      = this.communitiesCount;

      // Set class for small text size if count has more than 2 digits
      if (count > 99) {
        labelClass += ' nh-map-marker-cty-small';
      }

      this._marker = new MarkerWithLabel({
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
    }

    return this._marker;
  };

  // Community spot
  bozzuto.Neighborhoods.Community = function(node) {
    bozzuto.Neighborhoods.Spot.call(this, [node]);
  };

  bozzuto.Neighborhoods.Community.prototype = Object.create(bozzuto.Neighborhoods.Spot.prototype);
  bozzuto.Neighborhoods.Community.prototype.constructor = bozzuto.Neighborhoods.Community;

  bozzuto.Neighborhoods.Community.prototype.marker = function() {
    if (!this._marker) {
      this._marker = new google.maps.Marker({
        position: this.toLatLng(),
        title:    this.name,
        icon: {
          url:  '/images/neighborhoods/cty-marker.png',
          size: new google.maps.Size(40, 40)
        }
      });
    }

    return this._marker;
  };
})(jQuery);
