(function($) {

  window.REFRESH = window.REFRESH || {};

  REFRESH.fullHeroFormCarousel = function() {};

  REFRESH.fullHeroFormCarousel.prototype = {
    init: function(el) {
      this.cacheDOM(el);
    },

    cacheDOM: function(el) {
      this.$form = el;
      this.$progressButton = this.$form.find('.js-fullHeroFormProgress');
      this.$fieldset = this.$form.find('.js-fullHeroFormFieldset');
      this.$wrapper = this.$form.parents('.js-fullHeroContent');
      this.$currentFieldset;
      this.$nextFieldset = this.$fieldset[0];
      this.$checkbox = this.$form.find('.js-fullHeroFormCheckbox');

      this.listen();
    },

    incrementFormProgress: function(e) {
      this.$currentFieldset = $(this.$nextFieldset);
      this.$currentFieldset.removeClass('-visible');

      if ( $(e.currentTarget).hasClass('js-next') == true ) {
        this.$nextFieldset = this.$fieldset[ this.$currentFieldset.index() + 1 ];
      } else {
        this.$nextFieldset = this.$fieldset[ this.$currentFieldset.index() - 1 ];
      }

      if ( $(this.$nextFieldset).index() > 0 ) {
        this.$wrapper.addClass('-visible');
      } else if ( $(this.$nextFieldset).index() <= 0 ) {
        this.$wrapper.removeClass('-visible');
      }

      $(this.$nextFieldset).addClass('-visible');

      e.preventDefault();
    },

    toggleCheckbox: function(e) {
      $(e.currentTarget).parents('label').toggleClass('-checked');
    },

    listen: function() {
      this.$progressButton.on('click', this.incrementFormProgress.bind(this));
      this.$checkbox.on('click', this.toggleCheckbox.bind(this));
    }
  };

  $(document).ready(function() {
    return $('.js-fullHeroForm').each(function() {
      (new REFRESH.fullHeroFormCarousel()).init($(this));
    });
  });

})(jQuery);
