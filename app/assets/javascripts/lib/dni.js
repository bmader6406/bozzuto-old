$(document).ready(function() {
  if (!Cookies.get('disable_cookies')) {
    $('span.phone-number,dnr-replace').each(replaceDNINumber)
  }

  // Retreive DNI Number and then Replace
  
  function replaceDNINumber() {
    var $number   = $(this)
    var dniParams = fetchDNIparams()
    var data      = {
      format:   $number.attr('data-format'),
      customer: $number.attr('data-customer'),
      account:  $number.attr('data-account')
    }

    data[dniParams.key] = dniParams.value

    $.ajax({
      async:    false,
      url:      dniParams.url,
      dataType: 'jsonp',
      data:     data,
      success: function(response) {
        var dniNumber  = response.dniNumber || response.dni_number
        var leadSource = response.leadSourceValue || data.adsource

        updateToursURL(leadSource)
        updatePropertyWebsiteURL(leadSource)

        if (dniNumber.match(/\d{3}.\d{3}.\d{4}/)) {
          $number.text(dniNumber)
        }
      }
    })
  }

  // Ad Source Determination
  
  function fetchDNIparams() {
    var adSource       = undefined
    var adSourceParam  = getURLParameter('ctx_Ad Source')
    var referrerHost   = getHost(document.referrer)
    var adSourceCookie = {
      value: Cookies.get('bozzuto_ad_source'),
      set:   function(value) { Cookies.set('bozzuto_ad_source', value, { expires: 30 }) }
    }

    if (adSourceParam && adSourceParam.includes('-cheat')) {
      adSourceValue = adSourceParam.match(/^(.*)-cheat/)[1]
      adSource      = adSourceValue

      adSourceCookie.set(adSourceValue)
    } else if (adSourceCookie.value) {
      adSource = adSourceCookie.value
    } else if (adSourceParam) {
      adSource = adSourceParam

      adSourceCookie.set(adSourceParam)
    } else if (referrerHost && referrerHost != window.location.hostname) {
      adSource = 'referrer'
    } else {
      adSource = 'Bozzuto.com'
    }

    if (adSource == 'referrer') {
      return {
        url:  'https://dni.bozzuto.com/reffererDniNumber',
        key:  'referrer_host',
        value: referrerHost
      }
    } else {
      return {
        url:  'https://dni.bozzuto.com/dniNumber',
        key:  'adsource',
        value: adSource
      }
    }
  }

  // Tour URL Updates based on DNI Source

  function updateToursURL(value) {
    var $tourLinks = $('a[href*="tours.bozzuto.com"]')
    var srcRegex   = /([\?&]).*(src=[^&#]*)/

    /*
      The URL uses the format below for the src parameter:
      http://tours.bozzuto.com/tours/fenwick/schedule?src=partA.partB
        ­ partA can be e (email), w (website), l (landing page), etc.
        ­ partB can be ‘SearchEngine’, ‘SocialMedia’ etc.
        - For Property Website, part A will always be ‘w
    */

    for (var i = 0; i < $tourLinks.length; i++) {
      var $tourLink = $($tourLinks[i])
      var tourURL   = $tourLink.attr('href')

      if (tourURL.match(srcRegex)) {
        $tourLink.attr('href', tourURL.replace(srcRegex, '$1src=w.' + value))
      } else {
        $tourLink.attr('href', tourURL.replace(/(\?|$)/, '?src=w.' + value))
      }
    }
  }

  function updatePropertyWebsiteURL(leadSource) {
    $('[data-id="property-website-link"]').each(function() {
      var $link  = $(this)
      var params = ['utm_source', 'utm_campaign']

      params.forEach(function(param) {
        var url    = $link.attr('href')
        var regex  = new RegExp('([\?&])(' + param + '=[^&#]*)')
        var target = url.replace(regex, '$1' + param + '=' + leadSource)

        $link.attr('href', url.replace(regex, '$1' + param + '=' + leadSource))
      })
    })
  }
})
