(function($) {
	var transitions = {
		'WebkitTransition':  'webkitTransitionEnd',
		'MozTransition':     'transitionend',
		'OTransition':       'oTransitionEnd otransitionend',
		'transition':        'transitionend'
	};

	var $node = $('<div />');

	$.transitionEndEvent = null;

	for(var t in transitions){
			if($node[0].style[t] !== undefined) {
					$.transitionEndEvent = transitions[t];
			}
	}
})(jQuery);
