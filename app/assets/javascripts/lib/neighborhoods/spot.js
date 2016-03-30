(function($) {
  // Spot parent object
  bozzuto.Neighborhoods.Spot = function(map, node) {
    this.map              = map
    this.$node            = $(node);
    this.json             = $.parseJSON(this.$node.attr('data-jmapping'));
    this.id               = this.json['id'];
    this.category         = this.json['category'];
    this.name             = this.json['name'];
    this.communitiesCount = this.json['communities_count'];
    this.latitude         = this.json['point']['lat'];
    this.longitude        = this.json['point']['lng'];
  };

  bozzuto.Neighborhoods.Spot.prototype = {
    toLatLng: function() {
      return new google.maps.LatLng(this.latitude, this.longitude);
    },

    setMap: function(gMap) {
      this.clearEventListeners();

      this.marker().setMap(gMap);

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

      google.maps.event.addListener(marker, 'click', function() {
        self.map.showOverlay(self);
      });
    },

    overlayContent: function() {
      return this.$node.find('.nh-map-overlay')[0].outerHTML;
    }
  };

  // Neighborhood spot
  bozzuto.Neighborhoods.Neighborhood = function(map, node) {
    bozzuto.Neighborhoods.Spot.call(this, map, node);
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
  bozzuto.Neighborhoods.Community = function(map, node) {
    bozzuto.Neighborhoods.Spot.call(this, map, node);
  };

  bozzuto.Neighborhoods.Community.prototype = Object.create(bozzuto.Neighborhoods.Spot.prototype);
  bozzuto.Neighborhoods.Community.prototype.constructor = bozzuto.Neighborhoods.Community;

  bozzuto.Neighborhoods.Community.prototype.marker = function() {
    if (!this._marker) {
      this._marker = new google.maps.Marker({
        position:    this.toLatLng(),
        title:       this.name,
        anchorPoint: new google.maps.Point(0, -38),
        icon: {
          url:  '/images/neighborhoods/cty-marker.png',
          size: new google.maps.Size(40, 40)
        }
      });
    }

    return this._marker;
  };
})(jQuery);