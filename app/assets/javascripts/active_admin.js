//= require active_material
//= require active_admin/base
//= require activeadmin_reorderable
//= require polymorphic_select
//= require redactor
//= require chosen.jquery
//= require moment
//= require collapse
//= require transition
//= require bootstrap-datetimepicker.min

$(function() {
  var csrfToken = $('meta[name=csrf-token]').attr('content')
  var csrfParam = $('meta[name=csrf-param]').attr('content')
  var imgParams = '?' + csrfParam + '=' + encodeURIComponent(csrfToken)

  // boot redactor editors
  var redactorOpts = {
    "minHeight": 260,
    "buttons": [
      "html",
      "formatting",
      "bold",
      "italic",
      "unorderedlist",
      "orderedlist",
      "alignment",
      "link",
      "image"
    ],
    "formatting": [
      "p",
      "h1",
      "h2",
      "h3",
      "h4",
      "h5",
      "blockquote",
      "pre"
    ],
    "removeEmpty": [
      "p",
      "h1",
      "h2",
      "h3",
      "blockquote",
      "ul",
      "ol",
      "li",
      "span",
      "b",
      "i"
    ],

    imageUpload: '/admin/images' + imgParams,
    imageUploadParam: 'image[image]'
  };

  $(".redactor-input").redactor(redactorOpts);

  // boot chosen selects
  var chosenOpts = {
    "allow_single_deselect": true
  };

  $(".chosen-input").chosen(chosenOpts);

  // init chosen on new selects created by has_many
  $(document).on(
    'has_many_add:after',
    '.has_many_container',
    function(e, fieldset, container) {
      fieldset.find('select').chosen(chosenOpts);
    }
  );

  $('.bootstrap-datetime').datetimepicker({
    format: 'YYYY-MM-DD HH:mm:ss Z' // 2016-01-22 16:35:00 -0500
  });

  $('.bootstrap-date').datetimepicker({
    format: 'YYYY-MM-DD' // 2016-01-22
  });

  // adds error state to tab if any fields within have errors
  var $form = $('form.formtastic');
  var $tabList = $form.find('ul[role=tablist]');
  var $tabLinks = $tabList.find('> li');
  var $tabs = $form.find('div.tab-content > div');

  $tabs.each(function(i) {
    var $tab = $(this)

    if ($tab.find('.input.error').length > 0) {
      $tabLinks.eq(i).addClass('tab_with_errors')
    }
  });

});
