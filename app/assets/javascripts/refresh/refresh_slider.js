(function($) {

  window.REFRESH = window.REFRESH || {};

  REFRESH.refreshSlider = function() {};

  REFRESH.refreshSlider.prototype = {
    init: function(el) {
      this.cacheDOM(el);
    },

    cacheDOM: function(el) {
      this.$element = el;
      this.$slides = this.$element.find('.js-refreshSlide');
      this.$slidesControl = this.$element.find('.js-refreshSlideButton');
      this.$slidesControlPrev = this.$element.find('.js-refreshSlideButton.-previous');
      this.$slidesControlNext = this.$element.find('.js-refreshSlideButton.-next');
      this.$currentSlide = $(this.$slides[0]);
      this.$prevSlide;
      this.$nextSlide;

      this.$currentSlide.addClass('-active');
      this.$slidesControl.show();

      // if there are more than 1 slides, then the slider can build
      if (this.$slides.length > 1) {
        this.checkSlidePosition();
        this.listen();
      }
    },

    checkSlidePosition: function() {
      var index = this.$slides.index(this.$currentSlide);
      this.$slides.removeClass('-next-slide -previous-slide');
      if ( index === 0 ) {
        $(this.$slides[this.$slides.index(this.$currentSlide) + 1]).addClass('-next-slide');
        $(this.$slides[this.$slides.length - 1]).addClass('-previous-slide');
      } else if ( index >= this.$slides.length - 1 ) {
        $(this.$slides[0]).addClass('-next-slide')
        $(this.$slides[this.$slides.index(this.$currentSlide) - 1]).addClass('-previous-slide');
      } else {
        $(this.$slides[this.$slides.index(this.$currentSlide) - 1]).addClass('-previous-slide');
        $(this.$slides[this.$slides.index(this.$currentSlide) + 1]).addClass('-next-slide');
      }
    },

    changeSlide: function(e) {
      var index = this.$slides.index(this.$currentSlide);
      this.$currentSlide.removeClass('-active');

      if ( $(e.currentTarget).hasClass('-next') ) {
        if ( index >= this.$slides.length - 1 ) {
          this.$currentSlide = $(this.$slides[0]);
        } else {
          this.$currentSlide = $(this.$slides[this.$slides.index(this.$currentSlide) + 1]);
        }
      } else if ( $(e.currentTarget).hasClass('-previous') ) {
        if ( index === 0 ) {
          this.$currentSlide = $(this.$slides[this.$slides.length - 1]);
        } else {
          this.$currentSlide = $(this.$slides[this.$slides.index(this.$currentSlide) - 1]);
        }
      }

      this.$currentSlide.addClass('-active');
      this.checkSlidePosition();
    },

    listen: function() {
      this.$slidesControl.on('click', this.changeSlide.bind(this));
    },

    changeSelectText: function(event) {
      this.$text.html( this.$select.find('[value="' + this.$select.val() + '"]').text() );
    }
  };

  $(document).ready(function() {
    return $('.js-refreshSlides').each(function() {
      (new REFRESH.refreshSlider()).init($(this));
    });
  });

})(jQuery);
