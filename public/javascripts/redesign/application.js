BOZ = window.BOZ || {};

BOZ.init = function() {
  var body = document.body;

  var controller = BOZ.controller = body.getAttribute('data-controller').toLowerCase();
  var action     = BOZ.action     = body.getAttribute('data-action').toLowerCase();

  BOZ.common.init();

  if (controller !== "" && BOZ[controller] && typeof BOZ[controller][action] == "function" ) {
    BOZ[controller][action]();
  }
}

BOZ.common = {
  init: function() {
    $('[rel="external"]').attr('target', '_blank');
  }
}

$(BOZ.init);
