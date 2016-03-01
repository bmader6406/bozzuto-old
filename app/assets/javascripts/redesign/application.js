bozzuto = window.bozzuto || {};

bozzuto.log = function(message) {
  if (typeof window.console !== 'undefined') {
    console.log(message);
  }
};

bozzuto.warn = function(str) {
  if (typeof window.console !== 'undefined') {
    console.warn(str);
  }
};

bozzuto.init = function() {
  var body = document.body;

  var controller = bozzuto.controller = body.getAttribute('data-controller').toLowerCase();
  var action     = bozzuto.action     = body.getAttribute('data-action').toLowerCase();

  bozzuto.common.init();
  bozzuto.analytics.init();

  if (controller !== "" && bozzuto[controller] && typeof bozzuto[controller][action] == "function" ) {
    bozzuto[controller][action]();
  }
};

$(bozzuto.init);
