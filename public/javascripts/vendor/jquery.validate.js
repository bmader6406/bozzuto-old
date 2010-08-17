;(function($) {
	// Simple form validation
	$.fn.validate = function(options) {
		var opts = $.extend({}, $.fn.validate.defaults, options);

		return this.each(function() {
			var $this = $(this),
					o = $.meta ? $.extend({}, opts, $this.data()) : opts,
					errorMsgType = o.errorText.search(/{label}/);
					
			$this.bind('submit', function() {
				var hasError = false;
				
				$this.find(o.errorElement + '.' + o.errorClass).remove();
				$this.find(':input.' + o.inputErrorClass).removeClass(o.inputErrorClass);
				
				$this.find(':input.required').each(function() {
					var $input = $(this),
							fieldValue = $.trim($input.val()),
							labelText = $input.siblings('label').text().replace(o.removeLabelChar, ''),
							errorMsg = '';
					
					if(fieldValue === '') {
					  errorMsg = (errorMsgType > -1 ) ? errorMsg = o.errorText.replace('{label}',labelText) : errorMsg = o.errorText;
						hasError = true;
					} else if($input.hasClass('email')) {
					  if(!(/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/.test(fieldValue))) {
					    errorMsg = (errorMsgType > -1 ) ? errorMsg = o.emailErrorText.replace('{label}',labelText) : errorMsg = o.emailErrorText;
					    hasError = true;
					  }
					}
					
					if(errorMsg !== '') {
					  $input.addClass(o.inputErrorClass).after('<'+o.errorElement+' class="'+o.errorClass+'">' + errorMsg + '</'+o.errorElement+'>');
					}
				});
				
				return !hasError;
			});
		});
	};

	// default options
	$.fn.validate.defaults = {
		errorClass: 'error',
		errorText: '{label} is a required field.',
		emailErrorText: 'Please enter a valid {label}',
		errorElement: 'strong',
		removeLabelChar: '*',
		inputErrorClass: ''
	};
})(jQuery);
