// Place your application-specific JavaScript functions and classes for 
// Typus here.
document.write('<script type="text/javascript" src="/javascripts/admin/ckeditor/ckeditor.js"></script>'); 

$(function() {
  if ($('textarea.use-ckeditor').length > 0) {
    var data = $('textarea.use-ckeditor');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }
});

