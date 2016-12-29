(function($) {

  window.REFRESH = window.REFRESH || {};

  REFRESH.selectSwitch = function() {};

  REFRESH.selectSwitch.prototype = {
    init: function(el) {
      this.cacheDOM(el);
    },

    cacheDOM: function(el) {
      this.$element  = el;
      this.$select   = this.$element.find('.js-selectSwitchSelect');
      this.$text     = this.$element.find('.js-selectSwitchText');

      this.listen();
    },

    listen: function() {
      this.$element.on( 'change', this.changeSelectText.bind(this) );
    },

    changeSelectText: function(event) {
      this.$text.html( this.$select.find('[value="' + this.$select.val() + '"]').text() )
    }
  };

  $(document).ready(function() {
    return $('.js-selectSwitch').each(function() {
      (new REFRESH.selectSwitch()).init($(this));
    });
  });

})(jQuery);
