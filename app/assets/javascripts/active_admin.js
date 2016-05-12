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
  var csrfToken    = $('meta[name=csrf-token]').attr('content')
  var csrfParam    = $('meta[name=csrf-param]').attr('content')
  var uploadParams = '?' + csrfParam + '=' + encodeURIComponent(csrfToken)

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
      "image",
      "file"
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

    imageUpload: '/admin/images' + uploadParams,
    imageUploadParam: 'image[image]',

    fileUpload: '/admin/file_uploads' + uploadParams,
    fileUploadParam: 'file_upload[file]',

    formattingAdd: {
      'wysiwyg-12pt-font-add': {
        title: '12pt Formatting',
        args: ['p', 'class', 'wysiwyg-12pt-font']
      },
      'wysiwyg-12pt-font-remove': {
        title: '12pt Remove Formatting',
        args: ['p', 'class', 'wysiwyg-12pt-font' 'remove']
      }
    }
  };

  $(".redactor-input").redactor(redactorOpts);

  // boot chosen selects
  var chosenOpts = {
    allow_single_deselect: true,
    width: '100%'
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

  // mediaplex tag parsers
  var $parsers = $('.mediaplex_parser');

  $parsers.each(function(index, parser) {
    var $parser   = $(parser),
        $textarea = $parser.find('textarea'),
        $button   = $parser.find('button'),
        $errors   = $parser.find('p.multiplex_parser_errors'),
        $pageName = $('#mediaplex_tag_page_name'),
        $roiName  = $('#mediaplex_tag_roi_name');

    $button.click(function(e) {
      e.preventDefault();

      var code   = $textarea.val();
      var params = findMediaplexParams(code);

      if (params['page_name'] && params['roi_name']) {
        $pageName.val(params['page_name']);
        $roiName.val(params['roi_name']);

        $errors.text('');
        $errors.hide();
      } else {
        $errors.text('Error parsing code');
        $errors.show();
      }
    });
  });

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
});
