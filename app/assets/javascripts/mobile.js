//= require jquery-1.11.1.min.js
//= require owl.carousel.js

// Mobile Carousels
$(document).ready(function() {
  $('.owl-carousel').owlCarousel({
    autoPlay : false,
    items    : 1
  });
});

// Mobile Analytics (works with jQuery 1.11.1)
(function($) {
  window.bozzuto = window.bozzuto || {};

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

  bozzuto.ga = {
    debug: false,

    init: function() {
      if (bozzuto.ga.debug) {
        bozzuto.warn('Enabled GA tracking debug mode');
      }

      var $body = $('body');

      $body.on('a[data-track-event]', 'click', bozzuto.ga.trackEvent);
      $body.on('a[data-track-event-delay]', 'click', bozzuto.ga.trackEventWithDelay);
      $body.on('a[data-track-social]', 'click', bozzuto.ga.trackSocial);
      $body.on('a[data-track-social-delay]', 'click', bozzuto.ga.trackSocialWithDelay);

      $body.on('#new_contact_submission[data-track-event-delay]', 'submit', function(e) {
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
      if (bozzuto.ga.debug) {
        bozzuto.log(params);
      }

      _gaq.push(['_trackEvent', params[0], params[1], params[2]]);
      _gaq.push(['t2._trackEvent', params[0], params[1], params[2]]);
      _gaq.push(['t3._trackEvent', params[0], params[1], params[2]]);
    },

    submitSocial: function(params) {
      if (bozzuto.ga.debug) {
        bozzuto.log(params);
      }

      _gaq.push(['_trackSocial', params[0], params[1], params[2]]);
      _gaq.push(['t2._trackSocial', params[0], params[1], params[2]]);
      _gaq.push(['t3._trackSocial', params[0], params[1], params[2]]);
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

  bozzuto.doubleClick = {
    debug: false,

    init: function() {
      if (bozzuto.doubleClick.debug) {
        bozzuto.warn('Enabled DoubleClick tracking debug mode');
      }

      $('body').on('a[data-doubleclick-name]', 'click', bozzuto.doubleClick.trackClick);
    },

    trackClick: function(e) {
      var $this = $(this),
          name  = $this.attr('data-doubleclick-name'),
          cat   = $this.attr('data-doubleclick-cat');

      if (bozzuto.doubleClick.debug) {
        bozzuto.log('DoubleClick Name: ' + name);
        bozzuto.log('DoubleClick Cat: ' + cat);
      }

      if (name == undefined || cat == undefined) {
        return;
      }

      // Code provided by DoubleClick
      var axel = Math.random() + "";
      var a = axel * 10000000000000000;
      var spotpix = new Image();
      spotpix.src='http://ad.doubleclick.net/activity;src=4076175;type=conve135;cat=' + cat + ';u1=' + name + ';ord=1?';
    }
  };


  $(function() {
    bozzuto.ga.init();
    bozzuto.doubleClick.init();
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
  $('.twitter-update').on('a', 'click', function(e) {
    $(this).attr('data-track-social-delay', 'Twitter,Outbound Click,{current url}');
  });

  // Share this click handlers
  if (typeof window.SHARETHIS !== 'undefined') {
    var stSubmitGA = true;

    $('a.stbutton').on('mouseover', function() {
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
