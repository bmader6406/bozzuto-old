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

    var coordinates = bozzuto.coordinates
    var url         = '/yelp'
    var params      = $.param({
      'coordinates': coordinates,
      'search': {
        'category_filter': categories.join(','),
        'limit':           6,
        'radius':          0.75
      }
    });

    $.get(url, params, function(data, status) {
      $.each(data.businesses, function(index, biz) {
        var div     = template,
            bizJSON = {
              categories: biz.categories,
              id:         biz.id,
              point:      {
                lat: biz.location.coordinate.latitude,
                lng: biz.location.coordinate.longitude
              }
            };

        var address = biz.location.display_address.concat(formatPhone(biz.phone)).map(function(element) {
          if (element) return element
        });

        div = div.replace('{{json}}',       $.toJSON(bizJSON));
        div = div.replace('{{name}}',       biz.name);
        div = div.replace('{{url}}',        biz.url);
        div = div.replace('{{rating_img}}', biz.rating_img_url_small);
        div = div.replace('{{photo_img}}',  biz.image_url);
        div = div.replace('{{address}}',    address.join('<br />'));

        $('#large-map-side-bar').append(div);
      });
      updateMap();
    });
  }

  $("#map-lightbox").click(function(e) {
    e.preventDefault();

    $("#large-map-container").lightbox_me({
      onLoad: function () {
        var $largeMap = $('#large-map');

        $largeMap.css({ height: '420px', width: '850px' });

        $largeMap.jMapping({
          category_icon_options: function(category) {
            return {
              size: new google.maps.Size(32, 37),
              url:  iconImage(category)
            };
          },
          always_show_markers: true,
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
          $('#large-map-controls input').prop('checked', 'checked');
          search(checkedCategories());
          return false;
        });

        $('#large-map-container a.select-none').click(function(e) {
          $('#large-map-controls input').prop('checked', '');
          search(checkedCategories());
          return false;
        });
      }
    });
  });

  var iconImages = {
    'fitness':            '//google-maps-icons.googlecode.com/files/fitnesscenter.png',
    'parks':              '//google-maps-icons.googlecode.com/files/park-urban.png',
    'arts':               '//google-maps-icons.googlecode.com/files/music-classical.png',
    'beautysvc':          '//google-maps-icons.googlecode.com/files/aestheticscenter.png',
    'education':          '//google-maps-icons.googlecode.com/files/school.png',
    'coffee':             '//google-maps-icons.googlecode.com/files/coffee.png',
    'grocery':            '//google-maps-icons.googlecode.com/files/grocery.png',
    'hospitals':          '//google-maps-icons.googlecode.com/files/hospital.png',
    'transport':          '//google-maps-icons.googlecode.com/files/bus.png',
    'hotels':             '//google-maps-icons.googlecode.com/files/hotel.png',
    'drycleaninglaundry': '//google-maps-icons.googlecode.com/files/clothes.png',
    'bars':               '//google-maps-icons.googlecode.com/files/bar.png',
    'petservices':        '//google-maps-icons.googlecode.com/files/pets.png',
    'restaurants':        '//google-maps-icons.googlecode.com/files/restaurant.png',
    'shopping':           '//google-maps-icons.googlecode.com/files/shoppingmall.png'
  };

  function iconImage(key) {
    return iconImages[key] || '//google-maps-icons.googlecode.com/files/home.png';
  }
})();
