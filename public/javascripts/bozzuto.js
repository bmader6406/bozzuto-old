// original, unminified header script
// immediately sets a "narrowPage" class on the HTML tag if a page is narrow

/*
function align(de) {

  var d  = document,
      c  = ' narrowPage',
      db = d.body;

      if ( ! window.innerWidth) {
        w = ( de.clientWidth == 0 ) ? db.clientWidth : de.clientWidth;
      } else {
        w = window.innerWidth;
      }
  a( de, w, c );
}

function a( de, w, c ){

  var cn = de.className,
      hc = cn.indexOf(c) != -1,
      n  = w < 1130 && w > 980;

  if ( n && hc == false ) {
    de.className = cn + c;
  } else if ( !n && hc ){
    de.className = cn.replace(c, '');
  }

}

align(document.documentElement);
*/



//Collapse items by default on search results
function setSearchFormState() {
  $('.search #content > ul.results').find('.closed > :not(.header)').hide();
  $('.search #content > ul.results').find('ul.location-filters > li').addClass('closed');

  $('.search #content > ul.results > li > .header').searchExpandCollapse();
  $('.search #content > ul.results ul.location-filters .header').searchExpandCollapse({
    par: 'ul.location-filters'
  });
}

// object for storing global vars
window.bozzuto = {};

(function($) {
  $().ajaxSend(function(a, xhr, s) {
    xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*")
  });

  $(function() {

    $(window).resize(function() {
      align(document.documentElement);
    });

    $('#special-nav, .recently-viewed-actions').specialNavPopups();

    $('#secondary-nav').secondaryNav();

    $('#community-info, #apartments-by-area, #properties-by-type').onPageTabs();

    $('.twitter-update').latestTwitterUpdate();

    $('.property #slideshow').featuredSlideshow({
      dynamicPagination: false
    });
    setTimeout(function() {
      $(".property #slideshow").each(function() {
        var height = $(this).find('h1').height();
        $('.section', $(this)).css('top', height + 10).show();
      })
    }, 250);

    $('.home #slideshow').featuredSlideshow({
      dynamicPagination: false,
      onAdvance: function() {
        if (window._gaq != undefined) {
          window._gaq.push(['_trackEvent', 'Slideshows', 'Change Slide', 'Homepage']);
          window._gaq.push(['t2._trackEvent', 'Slideshows', 'Change Slide', 'Homepage']);
        }
      }
    });

    $('.mini-slideshow').featuredSlideshow();

    $('#masthead-slideshow, .slideshow').featuredSlideshow();

    $('.carousel').carousel();

    $('.green-homes-list li').captionAnimation();

    $('.community-icons a').toolTip();

    $('.listings .row:last-child').evenUp();

    $('.secondaryNav').secondaryNav();

    $('.features div.feature a').featurePhotoPopup();

    $('.features div.feature ul').makeacolumnlists({
      cols:        2,
      colWidth:    325,
      equalHeight: false,
      startN:      1
    });

    setSearchFormState();

    $('.project ul.project-updates li .info-link').hover(function() {
      if ($.browser.msie) {
        $(this).find('a').addClass('active').closest('div').find('.info-overlay').show();
      } else {
        $(this).find('a').addClass('active').closest('div').find('.info-overlay').fadeIn('fast');
      }
      return false;
    }, function() {
      if ($.browser.msie) {
        $(this).removeClass('active').closest('div').find('.info-overlay').hide();
      } else {
        $(this).removeClass('active').closest('div').find('.info-overlay').fadeOut('fast');
      }
      return false;
    });

    $('.expand-and-disappear').expandAndDisappear();

    $('.careers-banner').careersBanner();

    $('.partner-portrait').portrait();

    $('.partner-portrait-links a, .partners a, .careers-employee a').leaderLightbox();

    $('.floor-plan-view').floorPlanOverlay();

    $('.watch-video a').videoLightbox();

    $('#landing-map, #homes-map').bozzutoMap();

    //$('a.schedule-tour').scheduleTourIframe();

    $('#spinner').ajaxStart(function () {
      $(this).show();
    });
    $('#spinner').ajaxStop(function () {
      $(this).hide();
    });

    $('form.required-form').validate({
      errorElement: 'em'
    });

    $('#masthead-slideshow .aside ul').equalHeight({
      find: 'li > a'
    });

    $('.project .data').equalHeight();

    $('a[rel=external]').each(function() {
      $(this).attr('target', '_blank');
    });


    $('form#lasso-form').submit(function() {
      setCookie('lasso_email', $('input[name=Emails\[Primary\]]', this).val());
    });
    $('form#ufollowup-form').submit(function() {
      setCookie('ufollowup_email', $('input[name=prospectForm.email1]', this).val());
    });

    viewMoreFloorPlanGroups($('.floor-plans .floor-plan-group'));

    $('span.phone-number:has(script[type="text/javascript-dnr"])').replaceUsingDNR();

    function setCookie(name, value) {
      document.cookie = name + '=' + value + '; path=/';
    }


    var $mapCanvas = $('#map-canvas');

    if ($mapCanvas.length > 0) {
      $mapCanvas.jMapping({
        default_zoom_level: 14
      });
    }


    var installedWalkScore = false;

    $('li#walk-score-tab a').click(function() {
      if (!installedWalkScore) {
        installedWalkScore = true;

        var walkscoreJS = '<script type="text/javascript" src="http://www.walkscore.com/tile/show-walkscore-tile.php"></script>';

        $('div#walk-score').append(walkscoreJS);
      }
    });


    // Home page Featured News/Tom's Blog captions
    $('.home .latest-news, .home .bozzuto-blog').each(function() {
      var $container = $(this),
          $title     = $container.find('.title'),
          duration   = 250,
          offset;

      offset = -1 * $title.outerHeight(true);

      $title.css({ bottom: offset });

      $container.hover(function() {
        $title.animate({ bottom: '0px' }, duration);
      }, function() {
        $title.animate({ bottom: offset }, duration);
      });
    });

    (function() {
      var $greenFeatures = $('.green-features'),
        $hotspotTable = $greenFeatures.find('.hotspot-table'),
        $hotspots = $('#hotspots'),
        $hotspotDetails = $('#hotspot-details');

      $hotspotTable.find('tbody').delegate('tr', 'click', function() {
        var $this = $(this);

        if(!$this.hasClass('current')) {
          changeHotspot($this);
        }
      });

      $hotspots.delegate('a.hotspot', 'click', function(e) {
        var $this = $(this);

        if(!$this.hasClass('hover')) {
          changeHotspot($this);
        }

        e.preventDefault();
      });

      function changeHotspot($el) {
        var target = $el.attr('data-hotspot'),
          $hotspot = $('#hotspot-' + target),
          $hotspotDetail = $('#hotspot-detail-' + target),
          $hotspotRow = $('#hotspot-row-' + target);

        $hotspotTable.find('.current').removeClass('current');
        $hotspotRow.addClass('current');

        $hotspots.find('.hover').removeClass('hover');
        $hotspot.addClass('hover');

        $hotspotDetails.find('.current').removeClass('current');
        $hotspotDetail.addClass('current');
      }

      $('#ultra-green-package').bind('change', function() {
        var $this = $(this),
            $savings = $('.percent-savings');

        $greenFeatures.toggleClass('ultra-green-active');
        $hotspotTable.find('tfoot tr:first').toggle();

        if ($this.is(':checked')) {
          $savings.text($savings.attr('data-savings-with-ultra-green'));
        } else {
          $savings.text($savings.attr('data-savings'));
        }
      });
    })();
  });

  function viewMoreFloorPlanGroups($set) {
    return $set.each(function() {
      var self      = $(this),
          $rows     = $('ul.row', self),
          $viewMore = $('<a href="#">View More</a>');

      if ($rows.length > 2) {
        self.append($('<p class="view-more" />').append($viewMore));
      }

      $viewMore.bind('click', function() {
        $rows.slice(2).fadeIn();
        $viewMore.remove();
        return false;
      });
    });
  }


  ////
  // This plugin wraps Callsource DNR number replacement. It does the following:
  //   - sleeps initially for 1s to give other scripts and requests a chance to finish
  //   - sleeps for 300ms after each number is replaced, to prevent queuing up too
  //     many iframe requests and freezing the browser
  //   - set the font size
  //
  //  To achieve this, lookup.js was changed so replaceNumber returns a string
  //  instead of writing an iframe
  //
  $.fn.replaceUsingDNR = function() {
    var $set = $(this);

    if ($set.length > 0) {
      setTimeout(function() {
        processDnrScript($set);
      }, 1000);
    }

    function processDnrScript($numbers) {
      var $head     = $numbers.eq(0),
          $tail     = $numbers.slice(1),
          $script   = $('script[type="text/javascript-dnr"]', $head),
          fontSize  = $head.css('font-size'),
          color     = convertFromRGBToHex($head.css('color')),
          width     = parseInt($script.attr('-data-width')),
          height    = parseInt($script.attr('-data-height')),
          oldWidth  = frameWidth,
          oldHeight = frameHeight,
          iframe    = '';

      if (!isNaN(width) && !isNaN(height)) {
        setSize(width, height);
      }

      iframe = eval($script.html())
        .replace(/fontsize=[^&]+/, 'fontsize=' + fontSize)
        .replace(/fontfamily=[^&]+/, 'fontfamily=Arial')
        .replace(/textcolor=[^&]+/, 'textcolor=' + color);

      setSize(oldWidth, oldHeight);

      $head.html(iframe);

      if ($tail.length > 0) {
        setTimeout(function() {
          processDnrScript($tail);
        }, 300);
      }
    }

    function convertFromRGBToHex(color) {
      var matches = color.match(/rgb\((\d+),\s*(\d+),\s*(\d+)(,\s*\d+)?\)/);

      if (matches != null) {
        return RGBtoHex(matches[1], matches[2], matches[3]);
      } else {
        return color.substr(1);
      }

      return color;
    }

    function RGBtoHex(R,G,B) {return toHex(R)+toHex(G)+toHex(B)}
    function toHex(N) {
     if (N==null) return "00";
     N=parseInt(N); if (N==0 || isNaN(N)) return "00";
     N=Math.max(0,N); N=Math.min(N,255); N=Math.round(N);
     return "0123456789ABCDEF".charAt((N-N%16)/16)
          + "0123456789ABCDEF".charAt(N%16);
    }
  };


  // Equal height items
  $.fn.equalHeight = function(options) {
    var opts = $.extend({}, $.fn.equalHeight.defaults, options);

    return this.each(function() {
      var $this = $(this),
          o = $.meta ? $.extend({}, opts, $this.data()) : opts,
          maxHeight = 0;

      $this.find(o.find).each(function() {
        var $this = $(this),
            elemHeight = $this.height();
        maxHeight = (elemHeight > maxHeight) ? elemHeight : maxHeight;
      }).height(maxHeight);
    });
  };

  // default options
  $.fn.equalHeight.defaults = {
    find: 'li'
  };


  // map with custom markers
  $.fn.bozzutoMap = function() {
    if (this.length > 0) {
      var iconImages = {
        'ApartmentCommunity': '/images/structure/gicon-apartment.png',
        'HomeCommunity':      '/images/structure/gicon-home.png',
        'Project':            '/images/structure/gicon-project.png',
        'UpcomingApartment':  '/images/structure/gicon-project.png'
      };

      this.jMapping({
        side_bar_selector: '#map-properties:first',
        location_selector: '.property',
        marker_options: {
          anchorPoint: new google.maps.Point(-1, -36)
        },
        category_icon_options: function(category) {
          return {
            anchor: new google.maps.Point(14, 36),
            size:   new google.maps.Size(40, 36),
            url:    iconImages[category]
          }
        },
        map_config: function(map) {
          map.addControl(new GLargeMapControl3D());
        }
      });
    }

    return this;
  };


  ////
  // Expanding/collapsing on search results
  $.fn.searchExpandCollapse = function(options) {
    var opts = $.extend({}, $.fn.searchExpandCollapse.defaults, options);

    return this.each(function() {
      var $this = $(this);

      $this.bind('click', function() {
        var $par = $this.parentsUntil(opts.par).last();

        if ($par.hasClass('closed')) {
          $par.removeClass('closed').addClass('open').children(':hidden').slideDown(500);
          $par.siblings().removeClass('open').addClass('closed').children(':not(.header)').hide();
        } else {
          $par.removeClass('open').addClass('closed').children(':not(.header)').slideUp(250);
        }

        //TODO: ADD AJAX FILTERING/PAGINATION

      });
    });
  };

  $.fn.searchExpandCollapse.defaults = {
    par: 'ul.results'
  };


  ////
  // Read more links expand existing text
  $.fn.expandAndDisappear = function() {
    return this.each(function(){
      // define all our vars
      var $this    = $(this),
          $toshow  = $( $this.attr('href') ),
          $tohide  = $( $this.attr('data-to-hide') ),
          $all     = $toshow.add( $tohide ),
          $wrapper = $all.wrapAll('<div class="expand-wrapper"></div>').parent();

      // wrap both items in a div with relative positioning and a fixed height
      $wrapper.css('height', $wrapper.outerHeight() );

      // set both internal elements to position: absolute
      $all.css('width', $wrapper.width() ).css({
        'left' : '0',
        'position' : 'absolute',
        'top' : '0'
      });

      $this.bind('click', function(e){
        e.preventDefault();
        $this.fadeOut(100);
        $tohide.hide();
        $toshow.show();
        $wrapper.animate({
          'height' : $toshow.outerHeight()
        })
      });
    });
  }


  ////
  // workaround IE's bad text opacity issues
  $.fn.textFade = function( time ) {
    return this.each(function(){
      var time = ( time ) ? time : 350;
      if ($.browser.msie) {
        $(this).hide();
      } else {
        $(this).fadeOut( time );
      }
    });
  }


  $.fn.featurePhotoPopup = function() {
    this.each(function() {
      if ($(this).attr('href').match(/(jpe?g|gif|png)$/)) {
        var image = $('<img src="' + $(this).attr('href') + '" />');

        $(this).addClass('photo');

        $(this).click(function(e) {
          e.preventDefault();

          image.lightbox_me({
            appearEffect: 'show',
            overlaySpeed: 0,
            closeClick: true,
            destroyOnClose: true,
            lightboxSpeed: 'slow',
            centered: true,
            overlayCSS: {
              'background': '#000',
              'opacity': .5
            },
            onLoad:    function() {
              image.fadeTo(250, 1)
            },
            onClose: function() {
              image.css({
                'opacity' : 0
              })
            }
          });

          image.click(function() {
            image.trigger('close');
          })
        });
      }
    });
  };


  ////
  // special nav popups
  $.fn.specialNavPopups = function() {
    return this.each(function() {
      var lis = $("li:has(div.popup)", this),
          current;

      $("> a", lis).click(function() {
        var li = $(this).parent();

        if (isOpen(li)) {
          // this one's open, close it
          closePopup(li);
          current = null;
        } else {
          if (current) {
            // another one is open, close it
            closePopup(current);
          }
          // open this one
          current = openPopup(li);
        }
        return false;
      });

      $('form.errors', lis).each(function() {
        $(this).closest('li').find('> a').click();
      });
    });

    function isOpen(elem) {
      return elem.hasClass("open");
    }

    function openPopup(elem) {
      elem.addClass("open").find("div.popup").show();
      return elem;
    }

    function closePopup(elem) {
      elem.removeClass("open").find("div.popup").hide();
      return elem;
    }
  };


  ////
  // secondary nav
  $.fn.secondaryNav = function() {
    return this.each(function() {
      // insert the switch
      $("li:has(ul) > a", this).append(
        $('<span class="switch" />').html("+")
      );

      // switch handler
      $("a span", this).bind("click", function() {
        var $this = $(this),
            state = $this.html(),
            $targetList = $this.closest("li").find("> ul");

        if (state === "+") {
          $targetList.slideDown();
          $this.html("&ndash;");
        } else {
          $targetList.slideUp();
          $this.html("+");
        }

        return false;
      });

      // setup
      $("li:not(.current) ul:has(li.current)", this).show();
    $("li.current > ul", this).show();
      $("> li:has(li.current)", this).find("span.switch").html("&ndash;");
      $("> li:has(li.current) li.current", this).find("span.switch").html("+");
    $("li.current > a", this).find("span.switch").html("&ndash;");
    });
  };


  ////
  // even columns
  $.fn.evenUp = function() {
    return this.each(function() {
      var height = 0,
          $children = $(this).children();
      $children.each(function() {
        var childHeight = $(this).height();
        if (childHeight > height) {
          height = childHeight;
        }
      });
      $children.each(function() {
        if ($(this).height() < height) {
          $(this).css('height', height);
        }
      });
    });
  }


	////
	// tooltips on icon hovers
  $.fn.toolTip = function() {
		var tooltime				= 'inactive',
        $tooltip				= $('<div class="tooltip"></div>').appendTo('body'),
        $tooltipContent = $('<div></div>').appendTo($tooltip),
        $tooltipArrow		= $('<span class="tooltip-arrow"></span>').appendTo($tooltip);

    return this.each(function() {
      var $this        = $(this),

					name         = $(this).attr('data-name'),
					description  = $(this).attr('data-description'),

					$name        = $('<h4>' + name + '</h4>'),
					$description = $('<p>' + description + '</p>'),

          isSearch     = $('body').hasClass('search'),
          left         = (isSearch) ? 162 : 156,
          top          = (isSearch) ? 47 : 55;

      if (!$tooltip) {
      }

      $this.hover(function() {
        $tooltipContent.empty().append($name).append($description);

        $tooltip.css({
          'top'     : $this.offset().top + top,
          'left'    : $this.offset().left - left
        });

        if (tooltime != 'inactive') {
          clearTimeout(tooltime);
        } else {

          $tooltip.show();

          $tooltipArrow.animate({
            'top'    : "-7",
            'height' : 7
          }, 250);
        }
      }, function() {
        tooltime = setTimeout(function() {
          $tooltip.fadeOut(250);

          $tooltipArrow.animate({
            'top'    : 0,
            'height' : 0
          }, 250);

          tooltime = 'inactive';
        }, 750)
      }).click(function(e) {
        e.preventDefault();
      });
    });
  }


  ////
  // onpage tabs
  $.fn.onPageTabs = function() {
    return this.each(function() {
      var tabs = $("ul.nav li", this),
          sections = $(".section", this),
          current;

      tabs.each(function(i) {
        // store a reference to this tab's section
        $(this).data("section", sections.eq(i));
      }).find("a").click(function() {
        if (!$(this).parent().hasClass("current")) {
          // hide the current section
          current.removeClass("current");
          hide(current.data("section"));

          // show new section
          current = $(this).parent();
          current.addClass("current")
          show(current.data("section"));
        }
        return false;
      });

      // setup
      hide(sections);
      show(sections.eq(0));
      current = tabs.eq(0).addClass("current");

      function show(elements) {
        return elements.show();
      }

      function hide(elements) {
        return elements.hide();
      }
    });
  };


  ////
  // leadership portraits
  $.fn.portrait = function() {
    return this.each(function() {
      var $container = $(this),
          initialized = false,
          $imgLoader = $('<img src="/images/structure/bg-partner-portrait.jpg" />').load(init);

      $imgLoader[0].complete && init();

      function init() {
        if (!initialized) {
          var $links = $('.partner-portrait-links'),
              $images = $('<ul class="partner-portrait-images"></ul>').html($links.html()).prependTo($container),
              $screen = $('<div class="partner-portrait-screen"></div>').prependTo($container),
              mouseLeaveTimer;

          $links.children().each(function(i) {
            $(this).find('a').hover(function() {
              clearTimeout(mouseLeaveTimer);
              $screen.fadeTo(500, 1);
              $images.children().eq(i).fadeTo(125, 1);
            }, function() {
              $images.children().eq(i).stop().fadeTo(250, 0);
              mouseLeaveTimer = setTimeout(function() {
                $screen.fadeTo(1000, 0);
              }, 250)
            });
          });
        }
        initialized = true;
      }
    });
  };


  ////
  // leadership lightbox
  $.fn.leaderLightbox = function() {
    return this.each(function() {
      var $this = $(this),
          bioId = '#' + $this.attr('href').split('#')[1],
          $bio  = $(bioId).children();

      if (!$bio.data('closeAdded')) {
        $('<a href="#" class="partner-close">Close</a>').appendTo($bio.children());
        $bio.data('closeAdded', true);
      }

      $this.click(function(e) {
        e.preventDefault();

        $bio.lightbox_me({
          closeSelector: '.partner-close',
          appearEffect: 'show',
          disappearEffect: 'show',
          overlaySpeed: 0,
          destroyOnClose: true,
          centered: true,
          overlayCSS: {
            'background': '#000',
            'opacity': .6
          }
        });
      });
    });
  };


  ////
  // Floor plan overlay
  $.fn.floorPlanOverlay = function() {
    return this.each(function() {
      var $container = $(this),
          $image     = $('img', $container),
          $link      = $('.floor-plan-view-full', $container),
          $span      = $('span', $link),
          $pinterest = $('.pinterest-button', $container);

      $link.hide();
      $pinterest.hide();

      // delay further setup until the image is moused over
      // this is to allow time for the image to load. if we setup
      // too early, height may be 0
      $image.bind('mouseover', function() {
        // remove this setup handler
        $image.unbind('mouseover');

        $link.show();
        $pinterest.show();

            // container dimensions
        var containerWidth        = $image.width(),
            containerHeight       = $image.height(),

            // coordinates for center
            centerX               = containerWidth / 2,
            centerY               = containerHeight / 2,

            // span dimensions
            spanWidth             = $span.outerWidth(),
            spanHeight            = $span.outerHeight(),

            // pinterest button dimensions
            pinterestWidth        = $pinterest.outerWidth(),
            pinterestHeight       = $pinterest.outerHeight(),

            // spacing between buttons
            buttonSpacing         = 10,

            // flag for hovering over buttons
            hoveringOverLink      = false,
            hoveringOverPinterest = false;


        $container.addClass('floor-plan-view-js');


        // expand the link to completely cover the image
        $link.css({
          'width':  containerWidth + 'px',
          'height': containerHeight + 'px'
        });

        // center the span over the image
        $span.css({
          'top':  centerY - (spanHeight / 2) + 'px',
          'left': centerX - (spanWidth / 2) + 'px'
        });
        $span.hide();

        // position the pinterest button just below the span
        $pinterest.css({
          'top':  centerY + (spanHeight / 2) + buttonSpacing + 'px',
          'left': centerX - ($pinterest.outerWidth() / 2) + 'px'
        });
        $pinterest.hide();

        // pinterest button event handlers
        $pinterest.hover(function() {
          hoveringOverPinterest = true;
        }, function() {
          hoveringOverPinterest = false;
        });


        // link even handlers
        $link.bind({
          'mouseenter': function() {
            hoveringOverLink = true;

            $span.fadeIn();
            $pinterest.fadeIn();
          },

          'mouseleave': function() {
            hoveringOverLink = false;

            setTimeout(function() {
              if (!hoveringOverPinterest && !hoveringOverLink) {
                $span.fadeOut();
                $pinterest.fadeOut();
              }
            }, 150);
          },

          'click': function(e) {
            e.preventDefault();

            var url    = $(this).attr('href'),
                $image = $('<img src="' + url + '" class="floor-plan-overlay" />');

            $image.one('load', function() {
              $image.lightbox_me({
                appearEffect:   'show',
                overlaySpeed:   0,
                closeClick:     true,
                destroyOnClose: true,
                lightboxSpeed:  'slow',
                centered:       true,

                overlayCSS: {
                  'background': '#000',
                  'opacity': .50
                },
                onLoad: function() {
                  $image.fadeTo(250, 1)
                },
                onClose: function() {
                  $image.css({
                    'opacity' : 0
                  })
                }
              });

              $image.click(function() {
                $image.trigger('close');
              });
            }).each(function() {
              // make sure cached images fire the load event
              if (this.complete) {
                $(this).load();
              }
            });
          }
        });
      });
    });
  };


  ////
  // alternate slideshow for apartments page
  $.fn.featuredSlideshow = function(options) {
    var opts = $.extend({}, $.fn.featuredSlideshow.defaults, options);

    return this.each(function() {
      var $slideshow = $(this);
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
      var slideCount = $('ul.slides li.slide', $slideshow).length;
      var interval = $slideshow.find('ul').attr('data-interval');

      if (interval != undefined) {
        o.autoAdvanceInterval = parseInt(interval);
      }

      $slideshow.advancing = true;
      $slideshow.onAdvance = opts.onAdvance;

      if ( $slideshow.find('ul').attr('data-sync') == 'true') {
        $slideshow.data('linked', true);
        if ( $slideshow.attr('id') == 'masthead-slideshow' ) {
          $slideshow.data('master', true);
          $slideshow.sister = $('#slideshow');
          window.bozzuto.$masterslideshow = $slideshow;
        } else {
          $slideshow.sister = $('#masthead-slideshow');
        }
      }

      $slideshow.stopadvancing = function( isCommand ){
        if ( o.autoAdvance ) {
          $slideshow.advancing = false;
          clearInterval( $slideshow.advanceInterval );
          if ( $slideshow.data('linked') == true && isCommand != true ) {
            $slideshow.sister.trigger('stop');
          }
        }
      }

      $('ul.slides li.slide:eq(0)', $slideshow).addClass('current');

      // add slide counter
      if ($('ul.slides li.slide span.slideshow-counter', $slideshow).length > 0) {
        $('ul.slides li.slide', $slideshow).each(function(i) {
          $('span.slideshow-counter', $(this)).html(
              (i + 1) + ' of ' + slideCount + ':'
              );
        });
      }

      if (slideCount > 1) {
        if (o.dynamicPagination) {
          var pagination = $('<ul class="slideshow-pagination"></ul>');
          $('ul.slides li.slide', $slideshow).each(function(i) {
            $('<li><a href="#' + $(this).attr('id') + '">' + (i + 1) + '</a></li>').appendTo(pagination);
          });
          $('li:first', pagination).addClass('current');
          pagination.appendTo($slideshow);
        }

        if (o.autoAdvance) {
          $slideshow.advanceInterval = autoAdvance($slideshow, o);
          $slideshow.hover(function() {
            clearInterval( $slideshow.advanceInterval );
            clearInterval( $slideshow.sister.trigger('clearInterval') );
          }, function() {
            if ( $slideshow.advancing ){
              $slideshow.advanceInterval = autoAdvance($slideshow, o);
            }
            clearInterval( $slideshow.sister.trigger('startInterval') );
          });
        }

        $('.set-slideshow').each(function() {
          $(this).click(function(e) {
            var $this = $(this);
            $slideshow.stopadvancing();
            e.preventDefault();
            $slide = $($this.attr('href'));
            $this.featuredSlideshow.advance($slideshow, $slide, o);
            if ($(window).scrollTop() > $slide.offset().top + 100) {
              $(window).scrollTo($slide, 800);
            }
          });
        });

        $('ul.slideshow-pagination li a', $slideshow).click(function() {
          $slideshow.stopadvancing();
          var nextIndex = $('ul.slides li.slide:eq(' + ($(this).parent().prevAll().size()) + ')', $slideshow);
          $.fn.featuredSlideshow.advance($slideshow, nextIndex, o);
          return false;
        });
        $('.prev', $slideshow).click(function() {
          $slideshow.stopadvancing();
          if ($('ul.slides li.slide.current', $slideshow).prev().size() == 0) {
            var prev = $('ul.slides li.slide:last', $slideshow);
          } else {
            var prev = $('ul.slides li.slide.current', $slideshow).prev();
          }
          $.fn.featuredSlideshow.advance($slideshow, prev, o);
          return false;
        });
        $('.next', $slideshow).click(function() {
          $slideshow.stopadvancing();
          if ($('ul.slides li.slide.current', $slideshow).next().size() == 0) {
            var next = $('ul.slides li.slide:first', $slideshow);
          } else {
            var next = $('ul.slides li.slide.current', $slideshow).next();
          }
          $.fn.featuredSlideshow.advance($slideshow, next, o);
          return false;
        });

        $slideshow.bind({
         'advance' : function( e, slideindex, isCommand ){
           var $slide = $slideshow.find('li.slide').eq( slideindex );
           $.fn.featuredSlideshow.advance( $slideshow, $slide, o, false, true )
          },
          'clearInterval' : function(){
            clearInterval( $slideshow.advanceInterval );
          },
          'startInterval' : function(){
            if ( $slideshow.advancing ){
              $slideshow.advanceInterval = autoAdvance($slideshow, o);
            }
          },
          'stop' : function(){
            $slideshow.stopadvancing(true);
          }
        });

      } else {
        $('ul.slideshow-navigation, .prev, .next', $slideshow).hide();
      }

    });

    // private
    function autoAdvance($this, o) {
      if ( $this.data('linked') != true || $this.data('master') == true ) {
        return setInterval(function() {
          if ($('ul.slides li.slide.current', $this).next().size() == 0) {
            var next = $('ul.slides li.slide:first', $this);
          } else {
            var next = $('ul.slides li.slide.current', $this).next();
          }
          $.fn.featuredSlideshow.advance( $this, next, o, true );
        }, o.autoAdvanceInterval);
      }
    }
  };

  //public
  $.fn.featuredSlideshow.advance = function($slideshow, $slide, o, auto, isCommand) {
    if ( $slideshow.data('linked') && auto != true || $slideshow.data('master') ) {
      var slideindex = $slide.prevAll().length;
      if ( ! isCommand ) {
        $slideshow.sister.trigger('advance', [ slideindex ] );
      }
    }

    var slideIndex = $slide.prevAll().size(),
        $pagination = $('ul.slideshow-pagination', $slideshow);

    if (!$slide.hasClass('current')) {
      $slide.animate({ opacity: 0 }, 1, function() {
        $(this).addClass('on-deck');
      });
      $slide.animate({ opacity: 1 }, o.transitionTime, function() {
        $(this).siblings('.current').removeClass('current');
        $(this).addClass('current').removeClass('on-deck');
      });
    }

    $('li.current', $pagination).removeClass('current');
    $('li:eq(' + slideIndex + ')', $pagination).addClass('current');

    if (typeof($slideshow.onAdvance) == 'function') {
      $slideshow.onAdvance();
    }
  };

  $.fn.featuredSlideshow.defaults = {
    dynamicPagination:   true,
    autoAdvance:         true,
    autoAdvanceInterval: 5000,
    transitionTime:      450,
    onAdvance:           null
  };


  ////
  // fetch and insert the latest twitter update
  $.fn.latestTwitterUpdate = function() {
    $(this).each(function() {
      var $container = $(this),
          $link      = $('a.byline', $container);

      $('.message', $container).bind('click', function(e) {
        if (e.target == this) {
          window.location.href = $link.attr('href');
        }
      });
    });

    return this;
  };


  $.fn.attachSearchForm = function() {
    var form = this;
    this.find("input, select").bind('change', function () {
      $.get(form.action, $(form).serialize(), null, "script");
    });
    return this;
  };


  $.fn.carousel = function() {
    return $(this).each(function() {
      var $carousel  = $(this),
          $container = $('.slides ul', $carousel),
          $nav       = $('.nav', $carousel),
          $pager     = $('<p class="pager"></p>'),
          $pageLinks = null,
          $prev      = $('<a href="#" class="prev">Previous Slide</a>'),
          $next      = $('<a href="#" class="next">Next Slide</a>'),
          $slides    = $('> li', $container),
          slideCount = $slides.size(),
          offset     = $slides.first().outerWidth(true),
          setOffset  = offset * 3,
          setCount   = Math.ceil(slideCount / 3),
          currentSet = -1,
          duration   = 750;


      $carousel.bind({
        'carousel:setup': function() {
          // Build pager
          if (setCount > 1) {
            $nav.append($pager);

            for (var i = 1; i <= setCount; i++) {
              var klass;

              if (i == 1) {
                klass = 'first';
              } else if (i == setCount) {
                klass = 'last';
              } else {
                klass = '';
              }

              $pager.append($('<a href="#" class="' + klass + '" -data-page="' + i + '">' + i + '</a>'));
            }

            $pager.bind('click', function(e) {
              var page = $(e.target).attr('-data-page');

              if (page) {
                $carousel.trigger('carousel:load', parseInt(page) - 1);
              }

              e.preventDefault();
            });

            $pageLinks = $pager.find('a');
          }

          // Add prev/next buttons
          $nav.append($prev, $next);

          $container.css('width', slideCount * offset + 'px');

          // Prev button handler
          $prev.bind('click', function(e) {
            e.preventDefault();
            $carousel.trigger('carousel:prev');
          });

          // Next button handler
          $next.bind('click', function(e) {
            e.preventDefault();
            $carousel.trigger('carousel:next');
          });

          $carousel.trigger('carousel:load', 0);

          $slides.captionAnimation();

          $carousel.removeClass('loading');
        },

        'carousel:prev': function() {
          $carousel.trigger('carousel:load', currentSet - 1);
        },

        'carousel:next': function() {
          $carousel.trigger('carousel:load', currentSet + 1);
        },

        'carousel:load': function(e, set) {
          if (set > setCount || set < 0 || set == currentSet) {
            return;
          }

          currentSet = set;

          if (currentSet == setCount - 1) {
            $next.hide();
          } else {
            $next.show();
          }

          if (currentSet == 0) {
            $prev.hide();
          } else {
            $prev.show();
          }

          if ($pageLinks) {
            $pageLinks.removeClass('current').eq(currentSet).addClass('current');
          }

          $container.animate({ 'left': (-1 * setOffset * currentSet) + 'px' }, duration);
        }
      });

      $carousel.trigger('carousel:setup');
    });
  };


  $.fn.careersBanner = function() {
    var headerFadeDuration = 150,
        photoFadeDuration  = 250;

    return this.each(function() {
      var $container     = $(this),
          $links         = $container.find('.careers-employee a'),
          $baseHeader    = $container.find('.careers-header-base'),
          $currentHeader = $baseHeader;

      $links.each(function() {
        var $link    = $(this),
            $gray    = $link.find('img.gray'),
            $color   = null,
            timer    = null,
            $header  = $baseHeader.clone(),
            name     = $link.find('.careers-employee-name').text(),
            jobTitle = $link.find('.careers-employee-job-title').text(),
            company  = $link.find('.careers-employee-company').text();

        // Add color image
        $link.append('<img src="' + $gray.attr('data-color') + '" class="color" />');
        $color = $link.find('img.color');

        // Add header
        $header.removeClass('careers-header-base');

        $header.find('h1').text(name);
        $header.find('p').html(jobTitle + '<br />' + company);
        $header.css('display', 'none');

        $container.append($header);


        $link.hover(function() {
          clearTimeout(timer);

          // Fade in color photo
          $color.fadeIn(photoFadeDuration);

          // Replace header
          $currentHeader.fadeOut(headerFadeDuration);
          $header.fadeIn(headerFadeDuration);
          $currentHeader = $header;
        }, function() {
          timer = setTimeout(function() {
            // Fade out color photo
            $color.fadeOut(photoFadeDuration);

            // Header hasn't changed to another entry, so revert
            // back to the base header
            if ($currentHeader == $header) {
              $header.fadeOut(headerFadeDuration);
              $baseHeader.fadeIn(headerFadeDuration);
              $currentHeader = $baseHeader;
            }
          }, 200);
        });
      });
    });
  };


  $.fn.captionAnimation = function() {
    return $(this).each(function() {
      var $slide   = $(this),
          $caption = $('.caption', $slide),
          $title   = $('strong', $caption),
          duration = 250,
          offset;

      offset = -1 * (
        $caption.outerHeight() -
        parseInt($caption.css('padding-top')) -
        $title.outerHeight(true)
      );

      $caption.css({ bottom: offset });

      $slide.hover(function() {
        $caption.animate({ bottom: '0px' }, duration);
      }, function() {
        $caption.animate({ bottom: offset }, duration);
      });
    });
  };


  $.fn.scheduleTourIframe = function() {
    return $(this).each(function() {
      var $link = $(this);

      if ($link.attr('data-iframe') == 'yes') {
        $link.bind('click', function(e) {
          e.preventDefault();

          var url       = $link.attr('href'),
              width     = $link.attr('data-width'),
              height    = $link.attr('data-height'),
              $lightbox = $('<div id="schedule-tour-lightbox"></div>');

          $lightbox
            .append(iframeCode(url, width, height))
            .appendTo('body');

          $lightbox.lightbox_me({
            onClose: function() {
              $lightbox.remove();
            }
          });


          function iframeCode(url, width, height) {
            return '<iframe src="' + url + '" width="' + width + '" height="' + height + '"></iframe>';
          }
        });
      }
    });
  };
})(jQuery);
