bozzuto.apartment_communities = {
  redesign: function() {
    this.showHideSections();

    this.floorPlanImageModal();

    this.sendToPhoneModal();

    this.walkscoreModal();

    this.map();

    this.slideshow();

    // Split Features & Amenities into two lists
    $('.cty-features-content ul').makeacolumnlists({ cols: 2 });

    // videos
    $('.video').videoLightbox();
  },

  showHideSections: function() {
    $('.cty-section').each(function(i) {
      var showToggleClass = 'cty-section-toggle-show',
          hideToggleClass = 'cty-section-toggle-hide',
          $section        = $(this),
          $content        = $section.find('.cty-section-content'),
          $toggle         = $('<a class="cty-section-toggle"><i class="ico" aria-hidden="true"></i></a>');

      $(this).find('.cty-section-header h3').append($toggle);

      if (i == 0) {
        // show the first section by default
        $toggle.addClass(hideToggleClass);
        showContent();
      } else {
        $toggle.addClass(showToggleClass);
        hideContent();
      }

      $toggle.bind('click', function(e) {
        e.preventDefault();

        var $anchor = $(this);

        if ($anchor.hasClass(showToggleClass)) {
          enableHideToggle();
          showContent();
        } else {
          enableShowToggle();
          hideContent();
        }
      });

      function showContent() {
        $content.slideDown(400);
      }

      function hideContent() {
        $content.slideUp(300);
      }

      function enableShowToggle() {
        $toggle.removeClass(hideToggleClass);
        $toggle.addClass(showToggleClass);
      }

      function enableHideToggle() {
        $toggle.removeClass(showToggleClass);
        $toggle.addClass(hideToggleClass);
      }
    });
  },

  floorPlanImageModal: function() {
    $('.cty-floor-plan').each(function() {
      var $floorPlan = $(this),
          $link      = $floorPlan.find('.cty-floor-plan-image-link');

      $link.bind('click', function(e) {
        e.preventDefault();

        var url    = $(this).attr('href'),
            $image = $('<img src="' + url + '" class="floor-plan-overlay" />');

        $image.one('load', function() {
          $image.lightbox({ destroyOnClose: true }).bind('click', function() {
            $image.trigger('close');
          });
        }).each(function() {
          // make sure cached images fire the load event
          if (this.complete) {
            $(this).load();
          }
        });
      });
    });
  },

  sendToPhoneModal: function() {
    $('.cty-page-action-phone').bind('click', function(e) {
      e.preventDefault();

      $('.cty-send-to-phone-modal').lightbox();
    });
  },

  walkscoreModal: function() {
    $('.cty-walkscore-action').bind('click', function(e) {
      e.preventDefault();

      var script = '<script type="text/javascript" src="http://www.walkscore.com/tile/show-walkscore-tile.php"></script>';

      $('.cty-walkscore-modal').append(script).lightbox();
    });
  },

  map: function() {
    var $mapCanvas = $('#map-canvas');

    if ($mapCanvas.length > 0) {
      $mapCanvas.jMapping({
        default_zoom_level: 14
      });
    }
  },

  slideshow: function() {
    var $slideshow   = $('.cty-slideshow'),
        $thumbs      = $slideshow.find('.cty-slideshow-thumbs-inner a'),
        $images      = $slideshow.find('.cty-slideshow-images img'),
        $prevLink    = $slideshow.find('.cty-slideshow-prev'),
        $nextLink    = $slideshow.find('.cty-slideshow-next'),
        currentSlide = 0,
        totalSlides  = $images.size();

        console.log($images);

    // Thumbnail link
    $thumbs.bind('click', function(e) {
      e.preventDefault();

      var index = $(this).index();

      $slideshow.trigger('slideshow:showslide', index);
    });

    // Previous slide link
    $prevLink.bind('click', function(e) {
      e.preventDefault();

      $slideshow.trigger('slideshow:prevslide');
    });

    // Next slide link
    $nextLink.bind('click', function(e) {
      e.preventDefault();

      $slideshow.trigger('slideshow:nextslide');
    });

    // Slideshow event bindings
    $slideshow.bind({
      'slideshow:showslide': function(e, newSlide) {
        if (newSlide == currentSlide) {
          return;
        }

        $images.eq(currentSlide).fadeOut();
        $images.eq(newSlide).fadeIn();

        currentSlide = newSlide;
      },

      'slideshow:prevslide': function(e) {
        var newSlide = currentSlide == 0 ? (totalSlides - 1) : currentSlide - 1;

        $slideshow.trigger('slideshow:showslide', newSlide);
      },

      'slideshow:nextslide': function(e) {
        var newSlide = currentSlide == (totalSlides - 1) ? 0 : currentSlide + 1;

        $slideshow.trigger('slideshow:showslide', newSlide);
      }
    });
  }
};
