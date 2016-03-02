//= require active_material
//= require active_admin/base
//= require activeadmin_reorderable
//= require polymorphic_select
//= require redactor
//= require chosen.jquery

$(function() {

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
      "link"
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
    ]
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
      fieldset.find('select').chosen();
    }
  );

});
