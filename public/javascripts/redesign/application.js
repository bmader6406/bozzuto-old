bozzuto = window.bozzuto || {};

bozzuto.init = function() {
  var body = document.body;

  var controller = bozzuto.controller = body.getAttribute('data-controller').toLowerCase();
  var action     = bozzuto.action     = body.getAttribute('data-action').toLowerCase();

  bozzuto.common.init();

  if (controller !== "" && bozzuto[controller] && typeof bozzuto[controller][action] == "function" ) {
    bozzuto[controller][action]();
  }
}

bozzuto.common = {
  init: function() {
    $('[rel="external"]').attr('target', '_blank');
  }
}

$(bozzuto.init);
