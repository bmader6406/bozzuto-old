// Place your application-specific JavaScript functions and classes for
// Typus here.
// TODO Jeremy -- leaving this in place as a reference for now.

$(function() {
  if ($('textarea.use-ckeditor').length > 0) {
    var data = $('textarea.use-ckeditor');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }

  // floor plan form
  (function() {
    var imageUrl  = $('input[id$=floor_plan_image_url]').parent(),
        imageFile = $('input[id$=floor_plan_image]').parent();

    $('[id$="floor_plan_image_type"]').change(function() {
      var selected = parseInt($(':selected', this).val()),
          usesUrl  = 0,
          usesFile = 1;

      switch (selected) {
        case usesUrl:
          imageFile.hide();
          imageUrl.show();
          break;
        case usesFile:
          imageFile.show();
          imageUrl.hide();
          break;
      }
    }).change();
  })();

  // masthead slideshow form
  (function() {
    var imageFile    = $('input#masthead_slide_image').parent(),
        imageLink    = $('input#masthead_slide_image_link').parent(),
        sidebarText  = $('textarea#masthead_slide_sidebar_text_editor').parent(),
        mini         = $('select#masthead_slide_mini_slideshow_id').parent(),
        quote        = $('textarea[id$=quote_editor]').parent(),
        quoteBy      = $('input[id$=quote_attribution]').parent(),
        quoteJob     = $('input[id$=quote_job_title]').parent(),
        quoteCompany = $('input[id$=quote_company]').parent();

    $('select#masthead_slide_slide_type').change(function() {
      var selected     = parseInt($(':selected', this).val()),
          usesImage    = 0,
          usesText     = 1,
          usesMini     = 2,
          usesQuote    = 3;

      switch (selected) {
        case usesImage:
          imageFile.show();
          imageLink.show();
          mini.hide();
          sidebarText.hide();
          quote.hide();
          quoteBy.hide();
          quoteJob.hide();
          quoteCompany.hide();
          break;
        case usesText:
          imageFile.hide();
          imageLink.hide();
          mini.hide();
          sidebarText.show();
          quote.hide();
          quoteBy.hide();
          quoteJob.hide();
          quoteCompany.hide();
          break;
        case usesMini:
          imageFile.hide();
          imageLink.hide();
          mini.show();
          sidebarText.hide();
          quote.hide();
          quoteBy.hide();
          quoteJob.hide();
          quoteCompany.hide();
          break;
        case usesQuote:
          imageFile.hide();
          imageLink.hide();
          mini.hide();
          sidebarText.hide();
          quote.show();
          quoteBy.show();
          quoteJob.show();
          quoteCompany.show();
          break;
      }
    }).change();
  })();

  // brochure
  (function() {
    var brochureUrl  = $('input[id$=_brochure_url]').parent(),
        brochureFile = $('input[id$=_brochure]').parent();

    $('select[id$=_brochure_type]').change(function() {
      var selected = parseInt($(':selected', this).val()),
          usesUrl  = 0,
          usesFile = 1;

      switch (selected) {
        case usesUrl:
          brochureFile.hide();
          brochureUrl.show();
          break;
        case usesFile:
          brochureFile.show();
          brochureUrl.hide();
          break;
      }
    }).change();
  })();

  // project completion date
  (function() {
    var completionDate = $('select[id$=project_completion_date_1i]').parent();

    $('input[id=project_has_completion_date]').change(function() {
      if ($(this).is(':checked')) {
        completionDate.show();
      } else {
        completionDate.hide();
      }
    }).change();
  })();

  // project completion date
  (function() {
    var expirationDate = $('select[id$=promo_expiration_date_1i]').parent();

    $('input[id=promo_has_expiration_date]').change(function() {
      if ($(this).is(':checked')) {
        expirationDate.show();
      } else {
        expirationDate.hide();
      }
    }).change();
  })();

  // External Feeds sidebar refresh links
  (function() {
    $('a.refresh-feed').each(function(i, link) {
			var $link    = $(link),
					$message = $link.siblings('span.external-cms-message.please-wait');

			$link.bind('click', function() {
				$link.hide();
				$message.show();
			});
		});
  })();

  // mediaplex tag parser
  (function() {
    var $parser = $('#mediaplex-parser');

    if ($parser.length > 0) {
      var $textarea = $('textarea', $parser),
          $button   = $('input[type=submit]', $parser),
          $error    = $('.error', $parser),
          $pageName = $('input#mediaplex_tag_page_name'),
          $roiName  = $('input#mediaplex_tag_roi_name');

      $error.hide();

      $button.click(function(e) {
        e.preventDefault();

        var iframe = $textarea.val();
        var params = findMediaplexParams(iframe);

        if (params['page_name'] && params['roi_name']) {
          $pageName.val(params['page_name']);
          $roiName.val(params['roi_name']);

          $error.hide();
        } else {
          $error.show();
        }
      });
    }

    function findMediaplexParams(iframe) {
      var url    = $(iframe).attr('src'),
          params = {};

      if (url) {
        var paramsString = url.split('?')[1];

        $.each(paramsString.split('&'), function(i, param) {
          var pageName = findPageName(param);
          if (pageName) {
            params['page_name'] = pageName;
          }

          var roiName = findROIName(param);
          if (roiName) {
            params['roi_name'] = roiName;
          }
        });
      }

      return params;
    }

    function findPageName(string) {
      var results = string.match(/^page_name=(.+)$/) || [];

      if (results.length == 2) {
        return results[1];
      } else {
        return null;
      }
    }

    function findROIName(string) {
      var results = string.match(/^([^=]+)=1$/) || [];

      if (results.length == 2) {
        return results[1];
      } else {
        return null;
      }
    }
  })();

	// green package item hotspot
	(function() {
		var $selector = $('#green-package-hotspot-selector'),
				$img			= $selector.find('img'),
				$hotspot  = $selector.find('.hotspot.current'),
				$xInput   = $('input[name="green_package_item[x]"]'),
				$yInput   = $('input[name="green_package_item[y]"]');

		if ($selector.length == 0) {
			return;
		}

		$img.bind('click', function(e) {
			var x = e.pageX - $img.offset().left,
			    y = e.pageY - $img.offset().top;

			$xInput.val(x);
			$yInput.val(y);

			$hotspot.css({
				left: (x - 11) + 'px',
				top:  (y - 11) + 'px'
			});
		});
	})();

	// multi-destroy table with checkboxes
	(function() {
		$('table.multi-destroy').each(function() {
			var $table      = $(this),
					$button     = $table.find('.multi-destroy-button'),
					$selectAll  = $table.find('.multi-destroy-select-all'),
					$checkboxes = $table.find('.multi-destroy-checkbox'),
					$text       = $table.find('.multi-destroy-text');

			$table.bind('multi-destroy:change', function() {
				// enable/disable 'destroy' button
				if (checkedCount()) {
					$button.attr('disabled', '');
				} else {
					$button.attr('disabled', 'disabled');
				}

				// change text to 'Deselect All' if all are checked
				if (allAreChecked()) {
					$text.text('Deselect All');
					$selectAll.attr('checked', 'checked');
				} else {
					$text.text('Select All');
					$selectAll.attr('checked', '');
				}
			});

			$checkboxes.bind('click', function() {
				$table.trigger('multi-destroy:change');
			});

			$selectAll.bind('change', function() {
				if (allAreChecked()) {
					// all are selected, so deselect all
					$checkboxes.attr('checked', '');
				} else {
					// none/some are selected, so select all
					$checkboxes.attr('checked', 'checked');
				}

				$table.trigger('multi-destroy:change');
			});

			// initial setup
			$table.trigger('multi-destroy:change');


			function checked() {
				return $checkboxes.filter(':checked');
			}

			function checkedCount() {
				return checked().length;
			}

			function allAreChecked() {
				return checkedCount() == $checkboxes.length;
			}
		});
	})();

  $('#apartment_community_phone_number, #apartment_community_mobile_phone_number').mask('999.999.9999');
});
