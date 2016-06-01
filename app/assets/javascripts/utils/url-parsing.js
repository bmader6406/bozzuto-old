function getURLParameter(name) {
  var regex = new RegExp('[\?&]' + encodeURI(name) + '=([^&#]*)')
  var match = window.location.href.match(regex)
  
  return match ? match[1] : null
}

function getHost(url) {
  var match = url.match(/\/\/([^\/:]*)/)

  return match ? match[1] : null
}
