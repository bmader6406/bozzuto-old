(function($) {
  // Spot parent object
  bozzuto.Neighborhoods.Spot = function(node) {
    this.json             = $.parseJSON($(node).attr('data-jmapping'));
    this.id               = this.json['id'];
    this.category         = this.json['category'];
    this.name             = this.json['name'];
    this.communitiesCount = this.json['apartment_communities_count'];
    this.latitude         = this.json['point']['lat'];
    this.longitude        = this.json['point']['lng'];
  };

  bozzuto.Neighborhoods.Spot.prototype = {
    toLatLng: function() {
      return new google.maps.LatLng(this.latitude, this.longitude);
    }
  };

  // Place spot
  bozzuto.Neighborhoods.Place = function(node) {
    bozzuto.Neighborhoods.Spot.call(this, [node]);
  };

  bozzuto.Neighborhoods.Place.prototype = Object.create(bozzuto.Neighborhoods.Spot.prototype);
  bozzuto.Neighborhoods.Place.prototype.constructor = bozzuto.Neighborhoods.Place;

  bozzuto.Neighborhoods.Place.prototype.marker = function() {
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

  // Membership spot
  bozzuto.Neighborhoods.Membership = function(node) {
    bozzuto.Neighborhoods.Spot.call(this, [node]);
  };

  bozzuto.Neighborhoods.Membership.prototype = Object.create(bozzuto.Neighborhoods.Spot.prototype);
  bozzuto.Neighborhoods.Membership.prototype.constructor = bozzuto.Neighborhoods.Membership;

  bozzuto.Neighborhoods.Membership.prototype.marker = function() {
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
