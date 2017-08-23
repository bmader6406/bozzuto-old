(function() {
  var url = window.location.host;
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

        var address = biz.location.display_address.concat(biz.display_phone).map(function(element) {
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
          category_icon_options: iconImages,
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
    'fitness':         url + '/assets/map-icons/fitness.png',
    'parks':           url + '/assets/map-icons/parks.png',
    'arts':            url + '/assets/map-icons/arts.png',
    'beautysvc':       url + '/assets/map-icons/beauty.png',
    'education':       url + '/assets/map-icons/education.png',
    'coffee':          url + '/assets/map-icons/coffee.png',
    'grocery':         url + '/assets/map-icons/grocery.png',
    'hospitals':       url + '/assets/map-icons/hospital.png',
    'transport':       url + '/assets/map-icons/bus.png',
    'hotels':          url + '/assets/map-icons/hotels.png',
    'laundryservices': url + '/assets/map-icons/laundromat.png',
    'bars':            url + '/assets/map-icons/bars.png',
    'petservices':     url + '/assets/map-icons/pets.png',
    'restaurants':     url + '/assets/map-icons/restaurant.png',
    'shopping':        url + '/assets/map-icons/shopping.png'
  };

  function iconImage(key) {
    return iconImages[key] || url + '/assets/map-icons/home.png';
  }
})();
