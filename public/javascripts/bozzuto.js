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

  $(function() {
    changePageAlign();

    $(window).resize(function() {
      changePageAlign();
    });

    $("#special-nav").specialNavPopups();

    $("#secondary-nav").secondaryNav();

    $("#community-info, #apartments-by-area, #properties-by-type").onPageTabs();
    $('.twitter-update').latestTwitterUpdate();

    $(".property #slideshow, .home #slideshow").featuredSlideshow({
      'dynamicPagination' : false
    });

    $('.mini-slideshow').featuredSlideshow();

    setTimeout(function() {
      $(".property #slideshow").each(function() {
        var height = $(this).find('h1').height();
        $('.section', $(this)).css('top', height + 10).show();
      })
    }, 250);

    $("#masthead-slideshow, .slideshow").featuredSlideshow();

    $(".community-icons a").toolTip();

    $(".listings .row:last-child").evenUp();

    $(".secondaryNav").secondaryNav();

    $(".features div.feature a").featurePhotoPopup();

    $(".features div.feature ul").makeacolumnlists({cols:2, colWidth:325, equalHeight:false, startN:1});

    $(".services div.tips ul, .generic div.tips ul").makeacolumnlists({cols:3, colWidth:150, equalHeight:false, startN:1});

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
      $('.phone-number').replaceWith(function () {
        return getDNRiFrame(this, "xxx.xxx.xxxx", "1081055");
      });
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

    $('.phone-number').replaceWith(function () {
      return getDNRiFrame(this, "xxx.xxx.xxxx", "1081055");
    });
  });

  ;
  (function($) {
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
  })(jQuery);

  // map with custom markers
  (function($) {
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
  })(jQuery);

  //Video lightbox
  (function($) {
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

  })(jQuery);


  ////
  // Expanding/collapsing on search results
  (function() {
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

  })(jQuery);

  ////
  // Read more links expand existing text
  $.fn.expandAndDisappear = function() {
    return this.each(function(){
      
      // define all our vars
      var $this    = $(this),
          $toshow  = $( $this.attr('href') ),
          $tohide  = $( $this.attr('data-toHide') ),
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
        $tohide.textFade();
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
              'background': '#fff',
              'opacity': .01
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
          content = $($this.attr('href')),
          isSearch = $('body').hasClass('search'),
          left = (isSearch) ? 162 : 156,
          top = (isSearch) ? 47 : 55;

      if (!$tooltip) {
        $tooltip = $('<div class="tooltip"></div>')
            .appendTo('body');
        $tooltipContent = $('<div>' + content + '</div>')
            .appendTo($tooltip);
        ;
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

          $tooltip
              .css({
            'display' : 'block',
            'opacity' : '.01'
          })
              .fadeTo(250, 1);

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
          current.removeClass("current").data("section").hide();
          // show new section
          $(this).parent().addClass("current").data("section").show();
          current = $(this).parent();
        }
        return false;
      });

      // setup
      $(".section", this).hide().eq(0).show();
      current = tabs.eq(0).addClass("current");
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
          overlaySpeed: 0,
          destroyOnClose: true,
          centered: true,
          overlayCSS: {
            'background': '#fff',
            'opacity': .01
          },
          onLoad:    function() {
            $('.partner-bio-outer').fadeTo(250, 1)
          },
          onClose: function() {
            $('.partner-bio-outer').css({
              'opacity' : 0
            })
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
              'background': '#fff',
              'opacity': .01
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
  (function() {

    $.fn.featuredSlideshow = function(options) {

      var opts = $.extend({}, $.fn.featuredSlideshow.defaults, options);

      return this.each(function() {
        var $slideshow = $(this);
        var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
        var slideCount = $('ul.slides li.slide', $slideshow).length;

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
            var hoverInterval = autoAdvance($slideshow, o);
            $slideshow.hover(function() {
              clearInterval(hoverInterval);
            }, function() {
              hoverInterval = autoAdvance($slideshow, o);
            });
          }

          $('.set-slideshow').each(function() {
            $(this).click(function(e) {
              var $this = $(this);
              e.preventDefault();
              $slide = $($this.attr('href'));
              $this.featuredSlideshow.advance($slideshow, $slide, o);
              if ($(window).scrollTop() > $slide.offset().top + 100) {
                $(window).scrollTo($slide, 800);
              }
            });
          });

          $('ul.slideshow-pagination li a', $slideshow).click(function() {
            var nextIndex = $('ul.slides li.slide:eq(' + ($(this).parent().prevAll().size()) + ')', $slideshow);
            $.fn.featuredSlideshow.advance($slideshow, nextIndex, o);
            return false;
          });
          $('.prev', $slideshow).click(function() {
            if ($('ul.slides li.slide.current', $slideshow).prev().size() == 0) {
              var prev = $('ul.slides li.slide:last', $slideshow);
            } else {
              var prev = $('ul.slides li.slide.current', $slideshow).prev();
            }
            $.fn.featuredSlideshow.advance($slideshow, prev, o);
            return false;
          });
          $('.next', $slideshow).click(function() {
            if ($('ul.slides li.slide.current', $slideshow).next().size() == 0) {
              var next = $('ul.slides li.slide:first', $slideshow);
            } else {
              var next = $('ul.slides li.slide.current', $slideshow).next();
            }
            $.fn.featuredSlideshow.advance($slideshow, next, o);
            return false;
          });

        } else {
          $('ul.slideshow-navigation, .prev, .next', $slideshow).hide();
        }

      });
    };

    // private
    function autoAdvance($this, o) {
      return setInterval(function() {
        if ($('ul.slides li.slide.current', $this).next().size() == 0) {
          var next = $('ul.slides li.slide:first', $this);
        } else {
          var next = $('ul.slides li.slide.current', $this).next();
        }
        $.fn.featuredSlideshow.advance($this, next, o);
      }, o.autoAdvanceInterval);
    }

    ;

    //public
    $.fn.featuredSlideshow.advance = function($slideshow, $slide, o) {
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
    };

    $.fn.featuredSlideshow.defaults = {
      dynamicPagination: true,
      autoAdvance: true,
      autoAdvanceInterval: 4000,
      transitionTime: 450
    };

  })(jQuery);

  /**
   #  * Copyright (c) 2008 Pasyuk Sergey (www.codeasily.com)
   #  * Licensed under the MIT License:
   #  * http://www.opensource.org/licenses/mit-license.php
   #  *
   #  * Splits a <ul>/<ol>-list into equal-sized columns.
   #  *
   #  * Requirements:
   #  * <ul>
   #  * <li>"ul" or "ol" element must be styled with margin</li>
   #  * </ul>
   #  *
   #  * @see http://www.codeasily.com/jquery/multi-column-list-with-jquery
   #  */
  jQuery.fn.makeacolumnlists = function(settings) {
    settings = jQuery.extend({
      cols: 3,        // set number of columns
      colWidth: 0,        // set width for each column or leave 0 for auto width
      equalHeight: false,     // can be false, 'ul', 'ol', 'li'
      startN: 1        // first number on your ordered list
    }, settings);

    if (jQuery('> li', this)) {
      this.each(function(y) {
        var y = jQuery('.li_container').size(),
            height = 0,
            maxHeight = 0,
            t = jQuery(this),
            classN = t.attr('class'),
            listsize = jQuery('> li', this).size(),
            percol = Math.ceil(listsize / settings.cols),
            contW = t.width(),
            bl = ( isNaN(parseInt(t.css('borderLeftWidth'), 10)) ? 0 : parseInt(t.css('borderLeftWidth'), 10) ),
            br = ( isNaN(parseInt(t.css('borderRightWidth'), 10)) ? 0 : parseInt(t.css('borderRightWidth'), 10) ),
            pl = parseInt(t.css('paddingLeft'), 10),
            pr = parseInt(t.css('paddingRight'), 10),
            ml = parseInt(t.css('marginLeft'), 10),
            mr = parseInt(t.css('marginRight'), 10),
            col_Width = Math.floor((contW - (settings.cols - 1) * (bl + br + pl + pr + ml + mr)) / settings.cols);
        if (settings.colWidth) {
          col_Width = settings.colWidth;
        }
        var colnum = 1,
            percol2 = percol;
        jQuery(this).addClass('li_cont1').wrap('<div id="li_container' + (++y) + '" class="li_container"></div>');
        if (settings.equalHeight == 'li') {
          jQuery('> li', this).each(function() {
            var e = jQuery(this);
            var border_top = ( isNaN(parseInt(e.css('borderTopWidth'), 10)) ? 0 : parseInt(e.css('borderTopWidth'), 10) );
            var border_bottom = ( isNaN(parseInt(e.css('borderBottomWidth'), 10)) ? 0 : parseInt(e.css('borderBottomWidth'), 10) );
            height = e.height() + parseInt(e.css('paddingTop'), 10) + parseInt(e.css('paddingBottom'), 10) + border_top + border_bottom;
            maxHeight = (height > maxHeight) ? height : maxHeight;
          });
        }
        for (var i = 0; i <= listsize; i++) {
          if (i >= percol2) {
            percol2 += percol;
            colnum++;
          }
          var eh = jQuery('> li:eq(' + i + ')', this);
          eh.addClass('li_col' + colnum);
          if (jQuery(this).is('ol')) {
            eh.attr('value', '' + (i + settings.startN)) + '';
          }
          if (settings.equalHeight == 'li') {
            var border_top = ( isNaN(parseInt(eh.css('borderTopWidth'), 10)) ? 0 : parseInt(eh.css('borderTopWidth'), 10) );
            var border_bottom = ( isNaN(parseInt(eh.css('borderBottomWidth'), 10)) ? 0 : parseInt(eh.css('borderBottomWidth'), 10) );
            mh = maxHeight - (parseInt(eh.css('paddingTop'), 10) + parseInt(eh.css('paddingBottom'), 10) + border_top + border_bottom );
            eh.height(mh);
          }
        }
        jQuery(this).css({cssFloat:'left', width:'' + col_Width + 'px'});
        for (colnum = 2; colnum <= settings.cols; colnum++) {
          if (jQuery(this).is('ol')) {
            jQuery('li.li_col' + colnum, this).appendTo('#li_container' + y).wrapAll('<ol class="li_cont' + colnum + ' ' + classN + '" style="float:left; width: ' + col_Width + 'px;"></ol>');
          } else {
            jQuery('li.li_col' + colnum, this).appendTo('#li_container' + y).wrapAll('<ul class="li_cont' + colnum + ' ' + classN + '" style="float:left; width: ' + col_Width + 'px;"></ul>');
          }
        }
        if (settings.equalHeight == 'ul' || settings.equalHeight == 'ol') {
          for (colnum = 1; colnum <= settings.cols; colnum++) {
            jQuery('#li_container' + y + ' .li_cont' + colnum).each(function() {
              var e = jQuery(this);
              var border_top = ( isNaN(parseInt(e.css('borderTopWidth'), 10)) ? 0 : parseInt(e.css('borderTopWidth'), 10) );
              var border_bottom = ( isNaN(parseInt(e.css('borderBottomWidth'), 10)) ? 0 : parseInt(e.css('borderBottomWidth'), 10) );
              height = e.height() + parseInt(e.css('paddingTop'), 10) + parseInt(e.css('paddingBottom'), 10) + border_top + border_bottom;
              maxHeight = (height > maxHeight) ? height : maxHeight;
            });
          }
          for (colnum = 1; colnum <= settings.cols; colnum++) {
            var eh = jQuery('#li_container' + y + ' .li_cont' + colnum);
            var border_top = ( isNaN(parseInt(eh.css('borderTopWidth'), 10)) ? 0 : parseInt(eh.css('borderTopWidth'), 10) );
            var border_bottom = ( isNaN(parseInt(eh.css('borderBottomWidth'), 10)) ? 0 : parseInt(eh.css('borderBottomWidth'), 10) );
            mh = maxHeight - (parseInt(eh.css('paddingTop'), 10) + parseInt(eh.css('paddingBottom'), 10) + border_top + border_bottom );
            eh.height(mh);
          }
        }
        jQuery('#li_container' + y).append('<div style="clear:both; overflow:hidden; height:0px;"></div>');
      });
    }
  };

  ////
  // fetch and insert the latest twitter update
  $.fn.latestTwitterUpdate = function() {
    $(this).each(function() {
      var container = $(this),
          username = $(this).attr('data-twitter-username'),
          url = "http://twitter.com/statuses/user_timeline/" + username + ".json?callback=?";

      if (username == '') {
        return;
      }

      $.getJSON(url, { 'count': 1 }, function(data) {
        if ($.isArray(data) && data.length > 0) {
          var tweet = data[0];

          container.append(
              $('<p class="message">').text(tweet.text)
              ).append(
              $('<p class="byline">')
                  .text(tweet.user.screen_name)
                  .append(
                  $('<em>').text(formatTimestamp(tweet.created_at))
                  )
              );
        }
      });
    });

    return this;

    function formatTimestamp(timestamp) {
      var time = timestamp.split(" ");
      return time[1] + " " + time[2];
    }
  };

  $.fn.latestTwitterUpdate.monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  function changePageAlign() {
    var windowWidth = $(window).width();
    // if( windowWidth < 1200 && windowWidth > 980){
    if (windowWidth < 1130 && windowWidth > 980) {
      $(document.documentElement).addClass('narrowPage');
    } else {
      $(document.documentElement).removeClass('narrowPage');
    }
  }

  $().ajaxSend(
      function(a, xhr, s) {
        xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*")
      }
      );

  jQuery.fn.attachSearchForm = function() {
    var form = this;
    this.find("input, select").bind('change', function () {
      $.get(form.action, $(form).serialize(), null, "script");
      return false;
    });
    return this;
  };

})(jQuery);
