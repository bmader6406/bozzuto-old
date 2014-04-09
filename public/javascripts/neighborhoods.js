(function($) {
  $(function() {
    bozzuto.Neighborhoods.init();
  });

  bozzuto.Neighborhoods = {
    init: function() {
      this.initializeMap();
    },

    initializeMap: function() {
      var $maps = $('.nh-map');

      if ($maps.length > 0) {
        this.maps = $.map($maps, function($map) {
          var map = new bozzuto.Neighborhoods.Map($map);

          map.render();

          return map;
        });
      }
    }
  };
})(jQuery);
