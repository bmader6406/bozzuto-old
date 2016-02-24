//= require active_material
//= require active_admin/base
//= require activeadmin_reorderable
//= require polymorphic_select
//= require redactor

// boot redactor editors
$(document).ready(function(){
  var options = {
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

  $(".redactor-input").redactor(options);
});
