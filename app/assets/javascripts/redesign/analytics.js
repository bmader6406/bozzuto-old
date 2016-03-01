bozzuto.analytics = {
  init: function() {
    this.doubleClick.init();
  },

  doubleClick: {
    debug: false,

    init: function() {
      if (bozzuto.analytics.doubleClick.debug) {
        bozzuto.warn('Enabled DoubleClick tracking debug mode');
      }

      $('a[data-doubleclick-name]').one('click', bozzuto.analytics.doubleClick.track);
      $('form[data-doubleclick-name]').one('submit', bozzuto.analytics.doubleClick.track);
    },

    track: function(e) {
      var $this = $(this),
          name  = $this.attr('data-doubleclick-name'),
          cat   = $this.attr('data-doubleclick-cat');

      e.preventDefault();

      if (bozzuto.analytics.doubleClick.debug) {
        bozzuto.log('DoubleClick Name: ' + name);
        bozzuto.log('DoubleClick Cat: ' + cat);
      }

      if (name == undefined || cat == undefined) {
        return;
      }

      // Code provided by DoubleClick
      var axel = Math.random() + "";
      var a = axel * 10000000000000000;
      var spotpix = new Image();
      spotpix.src='http://ad.doubleclick.net/activity;src=4076175;type=conve135;cat=' + cat + ';u1=' + name + ';ord=1?';

      setTimeout(function() {
        $this[0][e.type]();
      }, 200);
    }
  }
};
