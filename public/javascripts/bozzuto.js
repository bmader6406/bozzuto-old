(function($) {

  $(function() {
    $("#special-nav").specialNavPopups();

    $(".secondary #secondary-nav").secondaryNav();

    //$(".about #masthead .container").slideshow();

    $("#community-info").communityInfoTabs();
    
    $(".apartments div.slideshow").featuredSlideshow();
    
    $(".services div.slideshow, .about div.slideshow").featuredSlideshow({
      callback: function(i,transTime) {
        $('#masthead ul.masthead-slideshow .current').animate({ opacity: 0 }, transTime);
  			$('#masthead ul.masthead-slideshow li:eq('+i+')').animate({ opacity: 1}, transTime, function() {
  				$(this).siblings('.current').removeClass('current');
  				$(this).addClass('current');
  			});
      }
    });

    $(".features div.feature ul").makeacolumnlists({cols:2, colWidth:325, equalHeight:false, startN:1});
    
    $(".services div.tips ul").makeacolumnlists({cols:3, colWidth:150, equalHeight:false, startN:1});
    
    //Collapse items by default on search results
    $('.search #content > ul.results').find('.closed > :not(.header)').hide();
    $('.search #content > ul.results').find('ul.location-filters > li').addClass('closed');
    
    $('.search #content > ul.results > li > .header').searchExpandCollapse();
    $('.search #content > ul.results ul.location-filters .header').searchExpandCollapse({
      par: 'ul.location-filters'
    });

    $('.project ul.project-updates li .info-link a').hover(function() {
      if($.browser.msie) {
        $(this).addClass('active').closest('div').find('.info-overlay').show();
      } else {
        $(this).addClass('active').closest('div').find('.info-overlay').fadeIn('fast');
      }
      return false;
    }, function() {
      if($.browser.msie) {
        $(this).removeClass('active').closest('div').find('.info-overlay').hide();
      } else {
        $(this).removeClass('active').closest('div').find('.info-overlay').fadeOut('fast');
      }
      return false;
    });
    
    $('.partner-portrait').portrait();
    
  });
  
  ////
  // Expanding/collapsing on search results
  (function() {
    $.fn.searchExpandCollapse = function(options) {
      var opts = $.extend({}, $.fn.searchExpandCollapse.defaults, options);
      return this.each(function() {
        var $this = $(this);
        
        $this.bind('click', function() {
          
          var $par = $this.parentsUntil(opts.par).last();
          
          if($par.hasClass('closed')) {
           $par.removeClass('closed').addClass('open').children(':hidden').slideDown(500);
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
            $targetList = $this.closest("li").find("ul");
  
        if(state === "+") {
          $targetList.slideDown();
          $this.html("&ndash;");
        } else {
          $targetList.slideUp();
          $this.html("+");
        }
        
        return false;
      });
      
      // setup
      $("li:not(.active) ul", this).hide();
      $("li.active").find("span.switch").html("&ndash;");
    });
  };

  ////
  // community info tabs
  $.fn.communityInfoTabs = function() {
    return this.each(function() {
      var tabs     = $("ul.nav li", this),
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
  // slideshow
  $.fn.slideshow = function() {
    return this.each(function() {
      var slides = $(".section", this),
          nav    = $('<ul class="nav" />'),
          navItems,
          current;

      // insert nav
      slides.each(function(i) {
        var li = $("<li />").append(
          $('<a href="#">' + (i + 1) + '</a>')
        );
        li.data("index", i);
        nav.append(li);
      });
      $(this).append(nav);
      navItems = $("li", nav);

      // nav click handler
      $("a", nav).click(function() {
        slides.eq(current).hide();
        navItems.eq(current).removeClass("current");

        current = $(this).parent().data("index");

        slides.eq(current).show();
        navItems.eq(current).addClass("current");
        return false;
      });

      // setup
      current = 0;
      slides.hide().eq(current).show();
      navItems.eq(current).addClass("current");
    });
  };
  
  ////
  // leadership portrats
  $.fn.portrait = function(){
    return this.each(function() {
      
      var $container  = $(this),
          initialized = false,
          $imgLoader  = $('<img src="images/structure/bg-partner-portrait.jpg" />').load(init);
                          
      $imgLoader[0].complete || init();

      function init(){
        if ( !initialized ){
        
          var $links     = $('.partner-portrait-links'),
              $images    = $('<ul class="partner-portrait-images"></ul>').html( $links.html() ).prependTo($container),
              $screen    = $('<div class="partner-portrait-screen"></div>').prependTo($container),
              mouseLeaveTimer;

          $links.children().each(function(i){
            $(this).find('a').hover(function(){
              clearTimeout(mouseLeaveTimer);
              $screen.fadeTo(500, 1);
              $images.children().eq(i).fadeTo(125, 1);
            }, function(){
              $images.children().eq(i).stop().fadeTo(250, 0);
              mouseLeaveTimer = setTimeout(function(){
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
	// alternate slideshow for apartments page

	(function() {

		$.fn.featuredSlideshow = function(options) {
			var opts = $.extend({}, $.fn.featuredSlideshow.defaults, options);
			return this.each(function() {
				var $this = $(this);
				var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
				
				if($('ul.slides li').size() > 1) {
					if(o.dynamicPagination) {

						var pagination = $('<ul class="slideshow-pagination"></ul>');

						$('ul.slides li', $this).each(function(i) {
							$('<li><a href="#'+$(this).attr('id')+'">'+(i+1)+'</a></li>').appendTo(pagination);
						});

						$('li:first', pagination).addClass('current');

						pagination.appendTo($this);
					}

					if(o.autoAdvance) {
						var hoverInterval = autoAdvance($this, o);

						$this.hover(function() {
							clearInterval(hoverInterval);
						}, function() {
							hoverInterval = autoAdvance($this, o);
						});

					}

					$('ul.slideshow-pagination li a', $this).click(function() {
						$.fn.featuredSlideshow.advance($('ul.slides li:eq('+($(this).parent().prevAll().size())+')'), o);
						return false;
					});
					$('ul.slideshow-navigation li a.prev', $this).click(function() {
						var prev = $('ul.slides li.current', $this).prev().size() == 0 ? $('ul.slides li:last', $this) : $('ul.slides li.current', $this).prev();
						$.fn.featuredSlideshow.advance(prev, o);
						return false;
					});
					$('ul.slideshow-navigation li a.next', $this).click(function() {
						var next = $('ul.slides li.current', $this).next().size() == 0 ? $('ul.slides li:first', $this) : $('ul.slides li.current', $this).next();
						$.fn.featuredSlideshow.advance(next, o);
						return false;
					});
					
				}
				

			});
		};

		// private
		function autoAdvance($this, o) {
			return setInterval(function() {
				$.fn.featuredSlideshow.advance($('ul.slides li.current', $this).next().size() == 0 ? $('ul.slides li:first', $this) : $('ul.slides li.current', $this).next(), o);
			}, o.autoAdvanceInterval);
		};

		//public
		$.fn.featuredSlideshow.advance = function($slide, o) {
			var paginationIndex = $slide.prevAll().size();
			$slide.stop().parent().parent().find('.slideshow-pagination li:eq('+paginationIndex+')').addClass('current').siblings().removeClass('current');
			$slide.animate({ opacity: 0 }, 1, function() {
				$(this).addClass('on-deck');
			});
			$slide.animate({ opacity: 1}, o.transitionTime, function() {
				$(this).siblings('.current').removeClass('current');
				$(this).addClass('current').removeClass('on-deck');
				if(o.callback !== '') {
				  o.callback(paginationIndex,o.transitionTime);
				}
			});
		};

		$.fn.featuredSlideshow.defaults = {
			dynamicPagination: true,
			autoAdvance: true,
			autoAdvanceInterval: 10000,
			transitionTime: 450,
			callback: ''
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
	jQuery.fn.makeacolumnlists = function(settings){
		settings = jQuery.extend({
			cols: 3,		// set number of columns
			colWidth: 0,		// set width for each column or leave 0 for auto width
			equalHeight: false, 	// can be false, 'ul', 'ol', 'li'
			startN: 1		// first number on your ordered list
		}, settings);

		if(jQuery('> li', this)) {
			this.each(function(y) {
				var y=jQuery('.li_container').size(),
			    	height = 0, 
			        maxHeight = 0,
					t = jQuery(this),
					classN = t.attr('class'),
					listsize = jQuery('> li', this).size(),
					percol = Math.ceil(listsize/settings.cols),
					contW = t.width(),
					bl = ( isNaN(parseInt(t.css('borderLeftWidth'),10)) ? 0 : parseInt(t.css('borderLeftWidth'),10) ),
					br = ( isNaN(parseInt(t.css('borderRightWidth'),10)) ? 0 : parseInt(t.css('borderRightWidth'),10) ),
					pl = parseInt(t.css('paddingLeft'),10),
					pr = parseInt(t.css('paddingRight'),10),
					ml = parseInt(t.css('marginLeft'),10),
					mr = parseInt(t.css('marginRight'),10),
					col_Width = Math.floor((contW - (settings.cols-1)*(bl+br+pl+pr+ml+mr))/settings.cols);
				if (settings.colWidth) {
					col_Width = settings.colWidth; 
				}
				var colnum=1,
					percol2=percol;
				jQuery(this).addClass('li_cont1').wrap('<div id="li_container' + (++y) + '" class="li_container"></div>');
				if (settings.equalHeight=='li') {
				    jQuery('> li', this).each(function() {
				        var e = jQuery(this);
				        var border_top = ( isNaN(parseInt(e.css('borderTopWidth'),10)) ? 0 : parseInt(e.css('borderTopWidth'),10) );
				        var border_bottom = ( isNaN(parseInt(e.css('borderBottomWidth'),10)) ? 0 : parseInt(e.css('borderBottomWidth'),10) );
				        height = e.height() + parseInt(e.css('paddingTop'), 10) + parseInt(e.css('paddingBottom'), 10) + border_top + border_bottom;
				        maxHeight = (height > maxHeight) ? height : maxHeight;
				    });
				}
				for (var i=0; i<=listsize; i++) {
					if(i>=percol2) { percol2+=percol; colnum++; }
					var eh = jQuery('> li:eq('+i+')',this);
					eh.addClass('li_col'+ colnum);
					if(jQuery(this).is('ol')){eh.attr('value', ''+(i+settings.startN))+'';}
					if (settings.equalHeight=='li') {
				        var border_top = ( isNaN(parseInt(eh.css('borderTopWidth'),10)) ? 0 : parseInt(eh.css('borderTopWidth'),10) );
				        var border_bottom = ( isNaN(parseInt(eh.css('borderBottomWidth'),10)) ? 0 : parseInt(eh.css('borderBottomWidth'),10) );
						mh = maxHeight - (parseInt(eh.css('paddingTop'), 10) + parseInt(eh.css('paddingBottom'), 10) + border_top + border_bottom );
				        eh.height(mh);
					}
				}
				jQuery(this).css({cssFloat:'left', width:''+col_Width+'px'});
				for (colnum=2; colnum<=settings.cols; colnum++) {
					if(jQuery(this).is('ol')) {
						jQuery('li.li_col'+ colnum, this).appendTo('#li_container' + y).wrapAll('<ol class="li_cont'+colnum +' ' + classN + '" style="float:left; width: '+col_Width+'px;"></ol>');
					} else {
						jQuery('li.li_col'+ colnum, this).appendTo('#li_container' + y).wrapAll('<ul class="li_cont'+colnum +' ' + classN + '" style="float:left; width: '+col_Width+'px;"></ul>');
					}
				}
				if (settings.equalHeight=='ul' || settings.equalHeight=='ol') {
					for (colnum=1; colnum<=settings.cols; colnum++) {
					    jQuery('#li_container'+ y +' .li_cont'+colnum).each(function() {
					        var e = jQuery(this);
					        var border_top = ( isNaN(parseInt(e.css('borderTopWidth'),10)) ? 0 : parseInt(e.css('borderTopWidth'),10) );
					        var border_bottom = ( isNaN(parseInt(e.css('borderBottomWidth'),10)) ? 0 : parseInt(e.css('borderBottomWidth'),10) );
					        height = e.height() + parseInt(e.css('paddingTop'), 10) + parseInt(e.css('paddingBottom'), 10) + border_top + border_bottom;
					        maxHeight = (height > maxHeight) ? height : maxHeight;
					    });
					}
					for (colnum=1; colnum<=settings.cols; colnum++) {
						var eh = jQuery('#li_container'+ y +' .li_cont'+colnum);
				        var border_top = ( isNaN(parseInt(eh.css('borderTopWidth'),10)) ? 0 : parseInt(eh.css('borderTopWidth'),10) );
				        var border_bottom = ( isNaN(parseInt(eh.css('borderBottomWidth'),10)) ? 0 : parseInt(eh.css('borderBottomWidth'),10) );
						mh = maxHeight - (parseInt(eh.css('paddingTop'), 10) + parseInt(eh.css('paddingBottom'), 10) + border_top + border_bottom );
				        eh.height(mh);
					}
				}
			    jQuery('#li_container' + y).append('<div style="clear:both; overflow:hidden; height:0px;"></div>');
			});
		}
	};


})(jQuery);
