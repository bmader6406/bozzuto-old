// Place your application-specific JavaScript functions and classes for 
// Typus here.
document.write('<script type="text/javascript" src="/javascripts/admin/ckeditor/ckeditor.js"></script>'); 

$(function() {
  if ($('textarea.use-ckeditor').length > 0) {
    var data = $('textarea.use-ckeditor');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }

  var imageUrl  = $('input#floor_plan_image_url').parent(),
      imageFile = $('input#floor_plan_image').parent();

  $('select#floor_plan_image_type').change(function() {
    var selected = $(':selected', this).val();

    if (selected == 0) {
      imageFile.hide();
      imageUrl.show();
    } else {
      imageFile.show();
      imageUrl.hide();
    }
  }).change();
});

