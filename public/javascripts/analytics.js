(function($) {
	window.bozzuto = window.bozzuto || {};

	var _gaq = window._gaq;

	bozzuto.ga = {
		debug: false,

		log: function(message) {
			if (typeof window.console !== 'undefined') {
				console.log(message);
			}
		},

		warn: function(str) {
			if (typeof window.console !== 'undefined') {
				console.warn(str);
			}
		},

		processParams: function(params) {
			var variables = {
				'{current url}': document.location.href
			};

			$.each(variables, function(name, value) {
				params = params.replace(new RegExp(name, 'g'), value);
			});

			return params;
		},

		submitEvent: function(params) {
			_gaq.push(['_trackEvent', params[0], params[1], params[2]]);
		},

		submitSocial: function(params) {
			_gaq.push(['_trackSocial', params[0], params[1], params[2]]);
		},

		trackEvent: function(e) {
			var $this  = $(this),
					params = bozzuto.ga.processParams($this.attr('data-track-event')).split(',');

			bozzuto.ga.submitEvent(params);
		},

		trackEventWithDelay: function(e) {
			var $this  = $(this),
					params = bozzuto.ga.processParams($this.attr('data-track-event-delay')).split(',');

			e.preventDefault();

			bozzuto.ga.submitEvent(params);

			setTimeout(function() {
				document.location = $this.attr('href');
			}, 100);
		},

		trackSocial: function(e) {
			var $this  = $(this),
					params = bozzuto.ga.processParams($this.attr('data-track-social')).split(',');

			bozzuto.ga.submitSocial(params);
		},

		trackSocialWithDelay: function(e) {
			var $this  = $(this),
					params = bozzuto.ga.processParams($this.attr('data-track-social-delay')).split(',');

			e.preventDefault();

			bozzuto.ga.submitSocial(params);

			setTimeout(function() {
				document.location = $this.attr('href');
			}, 100);
		}
	};


	$(function() {
		if (bozzuto.ga.debug) {
			bozzuto.ga.warn('Enabled GA tracking debug mode');

			_gaq = {
				push: function(params) {
					bozzuto.ga.log(params);
				}
			};
		}

		$('body').delegate('a[data-track-event]', 'click', bozzuto.ga.trackEvent);
		$('body').delegate('a[data-track-event-delay]', 'click', bozzuto.ga.trackEventWithDelay);
		$('body').delegate('a[data-track-social]', 'click', bozzuto.ga.trackSocial);
		$('body').delegate('a[data-track-social-delay]', 'click', bozzuto.ga.trackSocialWithDelay);

		$('body').delegate('#new_contact_submission[data-track-event-delay]', 'submit', function(e) {
			var $this  = $(this),
					params = bozzuto.ga.processParams($this.attr('data-track-event-delay')).split(','),
					topic  = $this.find('select[name="contact_submission[topic_id]"] option:selected').text();

			e.preventDefault();

			params.push(topic)

			bozzuto.ga.submitEvent(params);

			setTimeout(function() {
				$('body').undelegate('#new_contact_submission[data-track-event-delay]', 'submit');
				$this.trigger('submit');
			}, 100);
		});
	});

	// Facebook event callbacks
	window.fbAsyncInit = function() {
		FB.Event.subscribe('edge.create', function(targetURL) {
			bozzuto.ga.submitSocial(['Facebook', 'Like', document.location.href]);
		});

		FB.Event.subscribe('message.send', function(targetUrl) {
			bozzuto.ga.submitSocial(['Facebook', 'Send', document.location.href]);
		});
	};

	// Twitter event callbacks
	if (typeof window.twttr !== 'undefined') {
		twttr.ready(function(twttr) {
			twttr.events.bind('follow', function(event) {
				bozzuto.ga.submitSocial(['Twitter', 'Follow', document.location.href]);
			});
		});
	}

	// Outbound links from a tweet module
	$('.twitter-update').delegate('a', 'click', function(e) {
		$(this).attr('data-track-social-delay', 'Twitter,Outbound Click,{current url}');
	});

	// Share this click handlers
	if (typeof window.SHARETHIS !== 'undefined') {
		var stSubmitGA = true;

		$('a.stbutton').bind('mouseover', function() {
			if (stSubmitGA) {
				bozzuto.ga.submitSocial(['ShareThis', 'Open Click', document.location.href]);

				stSubmitGA = false;

				setTimeout(function() {
					stSubmitGA = true;
				}, 2000);
			}
		});
	}

})(jQuery);
