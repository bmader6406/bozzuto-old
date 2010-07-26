// Place your application-specific JavaScript functions and classes for 
// Typus here.

$(function() {
  if ($('textarea.use-ckeditor').length > 0) {
    var data = $('textarea.use-ckeditor');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }

  // floor plan form
  (function() {
    var imageUrl  = $('input[id$=floor_plan_image_url]').parent(),
        imageFile = $('input[id$=floor_plan_image]').parent();

    $('select#[id$=floor_plan_image_type]').change(function() {
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
    var imageFile   = $('input#masthead_slide_image').parent(),
        imageLink   = $('input#masthead_slide_image_link').parent(),
        sidebarText = $('textarea#masthead_slide_sidebar_text_editor').parent(),
        mini        = $('select#masthead_slide_mini_slideshow_id').parent();

    $('select#masthead_slide_slide_type').change(function() {
      var selected     = parseInt($(':selected', this).val()),
          usesImage    = 0,
          usesText     = 1,
          usesMini     = 2;

      switch (selected) {
        case usesImage:
          imageFile.show();
          imageLink.show();
          mini.hide();
          sidebarText.hide();
          break;
        case usesText:
          imageFile.hide();
          imageLink.hide();
          mini.hide();
          sidebarText.show();
          break;
        case usesMini:
          imageFile.hide();
          imageLink.hide();
          mini.show();
          sidebarText.hide();
          break;
      }
    }).change();
  })();

  // brochure
  (function() {
    var brochureUrl  = $('input[id$=_brochure_url]').parent(),
        brochureFile = $('input[id$=_brochure]').parent();

    $('select#[id$=_brochure_type]').change(function() {
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
});


