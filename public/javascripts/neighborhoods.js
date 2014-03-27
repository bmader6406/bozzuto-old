(function($) {
  $(function() {
    bozzuto.Neighborhoods.init();
  });

  bozzuto.Neighborhoods = {
    init: function() {
      this.initializeMap();
    },

    initializeMap: function() {
      var $map = $('.nh-map');

      if ($map.length > 0) {
        this.map = new bozzuto.Neighborhoods.Map($map);

        this.map.render();
      }
    }
  };
})(jQuery);
