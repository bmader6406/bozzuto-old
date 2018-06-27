//= require jquery
//= require jquery-migrate-min
//= require jquery_ujs
//= require vendor/jquery.json.js
//= require vendor/jquery.lightbox_me
//= require vendor/jquery.makecolumnlists
//= require vendor/jquery.metadata
//= require vendor/jquery.scrollTo-min
//= require vendor/jquery.stickem
//= require vendor/jquery.validate
//= require vendor/jmapping/jquery.jmapping
//= require vendor/jmapping/markermanager
//= require vendor/jmapping/StyledMarker
//= require utils/js.cookie
//= require utils/url-parsing
//= require lib/floodlight
//= require bozzuto
//= require refresh/index.js
//= require refresh/select_switch.js
//= require lib/analytics
//= require lib/plugins/jquery.videoLightbox
//= require lib/yelp-map
//= require lib/bozzuto_dni
//= require lib/transitscreen
$(document).ready(function () {
	$('span.phone-number,dnr-replace').each(replaceDNINumber)
});

function replaceDNINumber() {
	var $number   = $(this)
  var data      = {
    format:   $number.attr('data-format'),
    customer: $number.attr('data-customer'),
    account:  $number.attr('data-account')
  }
  call_dni_function(data.account, data.format, data.customer);
}
