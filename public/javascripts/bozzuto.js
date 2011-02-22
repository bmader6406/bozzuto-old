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

    $("#special-nav").specialNavPopups();

    $("#secondary-nav").secondaryNav();

    $("#community-info, #apartments-by-area, #properties-by-type").onPageTabs();
    $('.twitter-update').latestTwitterUpdate();

    $(".property #slideshow").featuredSlideshow({
      dynamicPagination: false
    });
    setTimeout(function() {
      $(".property #slideshow").each(function() {
        var height = $(this).find('h1').height();
        $('.section', $(this)).css('top', height + 10).show();
      })
    }, 250);

    $(".home #slideshow").featuredSlideshow({
      dynamicPagination: false,
      onAdvance: function() {
        if (window._gaq != undefined) {
          window._gaq.push(['_trackEvent', 'Slideshows', 'Change Slide', 'Homepage']);
        }
      }
    });

    $('.mini-slideshow').featuredSlideshow();

    $("#masthead-slideshow, .slideshow").featuredSlideshow();

    $(".community-icons a").toolTip();

    $(".listings .row:last-child").evenUp();

    $(".secondaryNav").secondaryNav();

    $(".features div.feature a").featurePhotoPopup();

    $(".features div.feature ul").makeacolumnlists({
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
    
    $('.partner-portrait').portrait();

    $('.partner-portrait-links a, .partners a').leaderLightbox();

    $('.floor-plan-view').floorPlanOverlay();

    $('.watch-video a').videoLightbox();

    $('#landing-map, #homes-map').bozzutoMap();

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
      var $head    = $numbers.eq(0),
          $tail    = $numbers.slice(1),
          $script  = $('script[type="text/javascript-dnr"]', $head),
          fontSize = $head.css('font-size'),
          iframe   = '';

      iframe = eval($script.html())
        .replace(/fontsize=[^&]+/, 'fontsize=' + fontSize)
        .replace(/fontfamily=[^&]+/, 'fontfamily=Arial');

      $head.html(iframe);

      if ($tail.length > 0) {
        setTimeout(function() {
          processDnrScript($tail);
        }, 300);
      }
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
      var baseIcon = new GIcon(G_DEFAULT_ICON);
      baseIcon.iconSize = new GSize(40, 36);
      baseIcon.iconAnchor = new GPoint(14, 36);
      baseIcon.infoWindowAnchor = new GPoint(14, 0);
      baseIcon.shadow = '/images/structure/gicon-shadow.png';
      baseIcon.shadowSize = new GSize(40, 36);

      var apartmentIcon = new GIcon(baseIcon),
          homeIcon = new GIcon(baseIcon),
          projectIcon = new GIcon(baseIcon);
      apartmentIcon.image = '/images/structure/gicon-apartment.png';
      homeIcon.image = '/images/structure/gicon-home.png';
      projectIcon.image = '/images/structure/gicon-project.png';

      this.jMapping({
        side_bar_selector: '#map-properties:first',
        location_selector: '.property',
        category_icon_options: {
          'ApartmentCommunity': new GIcon(apartmentIcon),
          'HomeCommunity':      new GIcon(homeIcon),
          'Project':            new GIcon(projectIcon)
        },
        map_config: function(map) {
          map.addControl(new GLargeMapControl3D());
        }
      });
    }

    return this;
  };


  //Video lightbox
  $.fn.videoLightbox = function(options) {
    var opts = $.extend({}, $.fn.videoLightbox.defaults, options);

    return this.each(function() {
      var $this = $(this);

      // Support for the Metadata Plugin.
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;

      $this.bind('click', function(e) {
        var $videoLightbox = $('<div id="video-lightbox"></div>');
        $videoLightbox.appendTo('body').append('<iframe src="' + $(this).attr('href') + '" height="' + o.height + '" scrolling="no" width="' + o.width + '"></iframe>');
        $videoLightbox.lightbox_me({
          onClose: function() {
            $videoLightbox.remove();
          }
        });
        e.preventDefault();
      });

    });
  };

  // default options
  $.fn.videoLightbox.defaults = {
    height: 372,
    width: 700
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
      $("li.current", this).find("span.switch").html("&ndash;");
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
  var tooltime = 'inactive', $tooltip, $tooltipArrow, $tooltipContents;

  $.fn.toolTip = function() {
    return this.each(function() {
      var $this = $(this),
          content = $($this.attr('href')).html(),
          isSearch = $('body').hasClass('search'),
          left = (isSearch) ? 162 : 156,
          top = (isSearch) ? 47 : 55;

      if (!$tooltip) {
        $tooltip = $('<div class="tooltip"></div>')
          .appendTo('body');
        $tooltipContent = $('<div>' + content + '</div>')
          .appendTo($tooltip);
        $tooltipArrow = $('<span class="tooltip-arrow"></span>')
          .appendTo($tooltip);
      }

      $this.hover(function() {
        $tooltipContent.html(content);
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
          $tooltipArrow.css({
            'top'    : 0,
            'height' : 0
          })
          tooltime = 'inactive';
        }, 500)
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
        return elements.css({
          'position': 'static',
          'left':     '0px',
          'top':      '0px'
        });
      }

      function hide(elements) {
        return elements.css({
          'position': 'absolute',
          'left':     '-9999px',
          'top':      '-9999px'
        });
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
          $bio = $($this.attr('href')).children();

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
            'background': '#fff',
            'opacity': .01
          }
        });
      });
    });
  };


  ////
  // Floor plan overlay
  $.fn.floorPlanOverlay = function() {
    return this.each(function() {
      var $link = $(this),
          $image = $('<img src="' + $link.attr('href') + '" class="floor-plan-overlay" />'),
          $button = $('<span class="floor-plan-view-full">View Full-Size</span>')
              .appendTo($link)
              .css({
            'display' : 'none',
            'top'     : ( $link.find('img').height() / 2 ) - 12
          });

      $link.bind({
        'mouseenter' : function() {
          $button.fadeIn();
        },
        'mouseleave' : function() {
          $button.fadeOut();
        },
        'click' : function(e) {
          e.preventDefault();

          $image.lightbox_me({
            appearEffect: 'show',
            overlaySpeed: 0,
            closeClick: true,
            destroyOnClose: true,
            lightboxSpeed: 'slow',
            centered: true,
            overlayCSS: {
              'background': '#000',
              'opacity': .50
            },
            onLoad:    function() {
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
          })
        }
      })
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
      if ($('ul.slides li.slide p.slideshow-counter', $slideshow).length > 0) {
        $('ul.slides li.slide', $slideshow).each(function(i) {
          $('p.slideshow-counter', $(this)).html(
              (i + 1) + ' of ' + slideCount + ' Photos'
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


  jQuery.fn.attachSearchForm = function() {
    var form = this;
    this.find("input, select").bind('change', function () {
      $.get(form.action, $(form).serialize(), null, "script");
    });
    return this;
  };
})(jQuery);
