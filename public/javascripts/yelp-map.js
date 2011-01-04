(function() {
  var template =
    '<div class="map-location biz" data-jmapping=\'{{json}}\'>' +
      '<div class="info-box clearfix">' + 
        '<h4><a href="{{url}}">{{name}}</a></h4>' +
        '<div class="info-photo"><a href="{{url}}"><img src="{{photo_img}}" /></a></div>' +
        '<div class="info-content"><img src="{{rating_img}}" /><p>{{address}}</p></div>' +
      '</div>' +
    '</div>';

  function updateMap() {
    $('#large-map').data('jMapping').update();
  }

  function formatPhone(phone) {
    if (phone.length == 10) {
      return '('+phone.substr(0, 3)+') '+phone.substr(3, 3)+'-'+phone.substr(6, 4);
    } else {
      return phone;
    }
  }

  function search(categories) {
    var returned = 0;

    $('#large-map-side-bar .biz').remove();

    if (categories.length == 0) {
      updateMap();
      return;
    }

    $.each(categories, function(category_index, category) {
      var url = 'http://api.yelp.com/business_review_search',
          params = $.param({
            'category': category,
            'ywsid':    bozzuto.yelpApiKey,
            'lat':      bozzuto.communityLatitude,
            'long':     bozzuto.communityLongitude,
            'limit':    6,
            'radius':   0.75
          });

      $.get(url, params, function(data, status) {
        $.each(data.businesses, function(index, biz) {
          var div     = template,
              bizJSON = {
                category: category,
                id:       ((category_index*1000)+(index)+2),
                point:    {
                  lat: biz.latitude,
                  lng: biz.longitude
                }
              };

          var address = [
            biz.address1,
            biz.address2,
            biz.address3,
            biz.city + ', ' + biz.state_code + ' ' + biz.zip,
            formatPhone(biz.phone)
          ];
          address = $.map(address, function(e) {
            if (e != "") {
              return e;
            }
          });

          div = div.replace('{{json}}',       $.toJSON(bizJSON));
          div = div.replace('{{name}}',       biz.name);
          div = div.replace('{{url}}',        biz.url);
          div = div.replace('{{rating_img}}', biz.rating_img_url_small);
          div = div.replace('{{photo_img}}',  biz.photo_url_small);
          div = div.replace('{{address}}',    address.join('<br />'));

          $('#large-map-side-bar').append(div);
        });
        updateMap();
      }, 'jsonp');
    });
  }

  $(document).ready(function() {
    var $mapCanvas = $('#map-canvas');

    if ($mapCanvas.length > 0) {
      $mapCanvas.jMapping({
        default_zoom_level: 14
      });

      $("#map-lightbox").click(function (e) {
        e.preventDefault();

        $("#large-map-container").lightbox_me({
          onLoad: function () {
            var $largeMap = $('#large-map');
            var baseIcon = new GIcon(G_DEFAULT_ICON);
            baseIcon.iconSize = new GSize(32, 37);
            baseIcon.iconAnchor = new GPoint(16, 37);
            baseIcon.infoWindowAnchor = new GPoint(16, 0);
            baseIcon.shadow = null;

            $largeMap.css({ height: '420px', width: '850px' });

            $largeMap.jMapping({
              category_icon_options: function(category) {
                var icon = new GIcon(baseIcon);

                switch(category) {
                  case 'fitness':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/fitnesscenter.png';
                    break;
                  case 'parks':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/park-urban.png';
                    break;
                  case 'arts':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/music-classical.png';
                    break;
                  case 'beautysvc':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/aestheticscenter.png';
                    break;
                  case 'education':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/school.png';
                    break;
                  case 'coffee':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/coffee.png';
                    break;
                  case 'grocery':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/grocery.png';
                    break;
                  case 'hospitals':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/hospital.png';
                    break;
                  case 'transport':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/bus.png';
                    break;
                  case 'hotels':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/hotel.png';
                    break;
                  case 'drycleaninglaundry':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/clothes.png';
                    break;
                  case 'bars':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/bar.png';
                    break;
                  case 'petservices':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/pets.png';
                    break;
                  case 'restaurants':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/restaurant.png';
                    break;
                  case 'shopping':
                    icon.image = 'http://google-maps-icons.googlecode.com/files/shoppingmall.png';
                    break;
                  default:
                    icon.image = 'http://google-maps-icons.googlecode.com/files/home.png';
                    break;
                }

                return icon;
              },
              default_zoom_level: 13,
              side_bar_selector: '#large-map-side-bar:first'
            });

            function checkedCategories() {
              var categories = [];
              $('#large-map-controls input[name=categories]:checked').map(function() {
                categories.push($(this).val());
              });
              return categories;
            }

            search(checkedCategories());

            $('#large-map-controls input').click(function(e) {
              search(checkedCategories());
            });

            $('#large-map-container a.select-all').click(function(e) {
              $('#large-map-controls input').attr('checked', 'checked');
              search(checkedCategories());
              return false;
            });

            $('#large-map-container a.select-none').click(function(e) {
              $('#large-map-controls input').attr('checked', '');
              search(checkedCategories());
              return false;
            });
          }
        });
      });
    }
  });
})();
