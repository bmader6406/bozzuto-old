// Place your application-specific JavaScript functions and classes for 
// Typus here.
document.write('<script type="text/javascript" src="/javascripts/admin/ckeditor/ckeditor.js"></script>'); 

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
        sidebarText = $('textarea#masthead_slide_sidebar_text').parent(),
        property    = $('select#masthead_slide_featured_property_id').parent();

    $('select#masthead_slide_slide_type').change(function() {
      var selected     = parseInt($(':selected', this).val()),
          usesImage    = 0,
          usesText     = 1,
          usesProperty = 2

      switch (selected) {
        case usesImage:
          imageFile.show();
          imageLink.show();
          property.hide();
          sidebarText.hide();
          break;
        case usesText:
          imageFile.hide();
          imageLink.hide();
          property.hide();
          sidebarText.show();
          break;
        case usesProperty:
          imageFile.hide();
          imageLink.hide();
          property.show();
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


