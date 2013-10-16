BOZ.apartment_communities = {
  redesign: function() {
    this.showHideSections();

    this.floorPlanImageModal();

    this.sendToPhoneModal();

    // Split Features & Amenities into two lists
    $('.cty-features-content ul').makeacolumnlists({ cols: 2 });
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

      var $modal = $('.cty-send-to-phone-modal');

      $modal.lightbox();
    });
  }
};
