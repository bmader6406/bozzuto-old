/*
 * DNI Implementation Script.
 * 
 * To find the DNI numbers corresponding to different lead source values and
 * replace it in the property website.
 * 
 */

var backwards_compatible = true;
var account;
var format;
var customer;
var referrer_string = document.referrer;
var referrer_host = (referrer_string.split('/'))[2];
var url_string = window.location.href;
var this_host = (url_string.split('/'))[2];
var match_referrer_value = '';
var cookie_expire_time = 2592000;
var cookie_name = "bozzuto_ad_source"

/*
 * function to get parameter values and call main DNI functions
 *
 * @param account, format, customer
 *
 */
function call_dni_function(account, format, customer) {
    account = account;
    format = format;
    customer = customer;
    set_dni(format, customer, account);
}

/*
 * function to set dni number
 *
 * @param  format, customer
 *
 */
function set_dni(format, customer, account) {
    var lead_source = "";
    var is_number_changed = false;
    var adsource_param
    
    if (get_adsource_cheat_string_from_url() !== undefined) {
        lead_source = get_adsource_cheat_string_from_url();
        if(lead_source.toLowerCase().indexOf("payperclick") >= 0){
            lead_source = "PayPerClick";
        }
        create_cookie(cookie_name, lead_source, cookie_expire_time);
    }
    else if (read_cookie(cookie_name) !== null) {
        lead_source = read_cookie(cookie_name);
    }
    else if (get_adsource_from_url() !== '') {
        lead_source = get_adsource_from_url();
        if(lead_source.toLowerCase().indexOf("payperclick") >= 0){
            lead_source = "PayPerClick";
        }
        create_cookie(cookie_name, lead_source, cookie_expire_time);
    }
    else if (referrer_host != null && this_host.indexOf(referrer_host) == -1 && referrer_host.indexOf('undefined') == -1) {
        match_referrer(referrer_host, format, customer, account);
        is_number_changed = true;
    }
    else {
        lead_source = 'PropertyWebsite';
        create_cookie(cookie_name, lead_source, cookie_expire_time);
    }

    if (!is_number_changed) {
        replace_number(format, customer, lead_source, account);
    }
}

/*
 * function to replace number from Bozzuto DNI API
 *
 * @param  format, customer, campaign, adsource
 *
 */
function replace_number(format, customer, adsource, account) {
    var dni_number, lead_source;
    
    if ((customer == null || customer == "undefined") && customer.length > 0) {
        customer = customer;
    }
    if ((adsource == null || adsource == "undefined") && adsource.length > 0) {
        adsource = adsource;
    }
    if (format == null || format == "undefined") {
        format = '(xxx)-xxx-xxxx';
    }
    if (adsource == null) {
        adsource = 'undefined';
    }

    jQuery.ajax({
        url: 'https://dni.bozzuto.com/dniNumber',
        type: 'GET',
        dataType: 'jsonp',
        data: {'format': format, 'customer': customer, 'adsource': adsource, 'account' : account},
        success: function (response) {
            dni_number = response.dniNumber;
            lead_source = response.leadSourceValue;
            if(lead_source != '') {
                create_cookie(cookie_name, lead_source, cookie_expire_time);
                update_tours_url(lead_source);
            }else{
                update_tours_url(adsource);
            }
            display_dni_number(dni_number);
        },
        async: false
    });
}

/*
 * function to display dni number in website
 *
 * @param dni_number
 *
 */
function display_dni_number(dni_number) {
    var dni_number_count = dni_number.replace(/[^0-9]/g,"").length
    if (dni_number != '' && dni_number_count >= 10) {
        jQuery('.phonenumber').text(dni_number);
        // jQuery('.phone-number').text(dni_number);
    }
}

/*
 * function to update tours bozzuto url
 *
 * @param lead_source
 *
 */
function update_tours_url(lead_source){
    var value = lead_source;
    var tour_url_href;
    var tour_url = jQuery('a[href*="tours.bozzuto.com/tours"]');
    if(tour_url.length > 0) {
        tour_url_href = tour_url.attr('href');
        var new_tour_url = set_tour_url(tour_url, value, tour_url_href);
        tour_url.attr('href', new_tour_url);
    }
    var tour_url = jQuery('a[onclick*="tours.bozzuto.com/tours"]');
    if(tour_url.length > 0) {
        tour_url_href = tour_url.attr('onclick');
        var onclick_url = tour_url_href.match(/'([^']+)'/)[1];
        var new_tour_url = set_tour_url(tour_url, value, onclick_url);
        tour_url_href = tour_url_href.replace(onclick_url, new_tour_url);
        tour_url.attr('onclick', tour_url_href);
    }
}

function set_tour_url(tour_url, value, tour_url_href){
        var new_tour_url = "";
        if(tour_url_href.indexOf('?') >= 0){
            var tour_url_array = tour_url_href.split('?');
            var prefix_tour_url = tour_url_array[0];
            var suffix_tour_url = tour_url_array[1];
            var new_parameters = "";
            if(suffix_tour_url.indexOf('&') >= 0){
                var parameter_array = suffix_tour_url.split('&');
                var is_src_present = false;
                for(var i=0; i < parameter_array.length; i++){
                     if(parameter_array[i].indexOf('src') >= 0){
                         is_src_present = true;
                         parameter_array[i] = 'src=w.'+ value;
                     }
                     if(i !== 0) {
                         new_parameters = new_parameters + '&';
                     }
                    new_parameters = new_parameters + parameter_array[i];
                }
                if(!is_src_present) {
                    new_parameters = new_parameters + '&src=w.'+ value;
                }
            }
            else if(suffix_tour_url.indexOf('src') >= 0){
                new_parameters = 'src=w.'+ value;
            } else{
                new_parameters = suffix_tour_url + '&src=w.'+ value;
            }
            new_tour_url = prefix_tour_url +'?'+ new_parameters;
        } else {
            new_tour_url = tour_url_href + '?src=w.'+ value;
        }

        return new_tour_url;
}

/*
 * function to get adsource parameter from url
 *
 * @param null
 * 
 */
function get_adsource_from_url() {
    var adsource_param = '';
    var url_string_lower = url_string.toLowerCase();
    
    adsource_param = get_parameter("utm_source", url_string_lower);
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("utm%5Fsource", url_string_lower);
    }
    
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ct_Ad%20Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad%20Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ct_Ad\\+Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad\\+Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad_Source", url_string);
    }

    return adsource_param;
}

/*
 * function to get adsource parameter from url and check if it contains "-cheat" this string
 *
 * @param null
 * 
 */
function get_adsource_cheat_string_from_url() {
    var adsource_param = '';
    var url_string_lower = url_string.toLowerCase();
    
    adsource_param = get_parameter("utm_source", url_string_lower);
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("utm%5Fsource", url_string_lower);
    }
    
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ct_Ad%20Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad%20Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ct_Ad\\+Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad\\+Source", url_string);
    }
    if (adsource_param.length == 0) {
        adsource_param = get_parameter("ctx_Ad_Source", url_string);
    }
    
    if(adsource_param.toLowerCase().indexOf("-cheat") >= 0){
        adsource_param = adsource_param.substr(0, adsource_param.indexOf('-cheat')); 
        return adsource_param;
    }
}
/*
 * function to check if http referrer has corresponding lead source value and replace correspomding new phonenumber
 *
 * @param referrer_host, format, customer
 *
 */
function match_referrer(referrer_host, format, customer, account) {
    var lead_source;
    var dni_number;
    jQuery.ajax({
        url: 'https://dni.bozzuto.com/referrerDniNumber',
        type: 'GET',
        dataType: 'jsonp',
        data: {'referrer_host': referrer_host, 'format': format, 'customer': customer, 'account' : account },
        success: function (response) {
            lead_source = response.leadSourceValue;
            dni_number = response.dni_number;
            create_cookie(cookie_name, lead_source, cookie_expire_time);
            update_tours_url(lead_source);
            display_dni_number(dni_number);

        },
        async: false
    });
}

/*
 * function to create cookie
 *
 * @param name, value, seconds
 *
 */
function create_cookie(name, value, seconds) {
    if (seconds) {
        var date = new Date();
        date.setTime(date.getTime() + (seconds * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else
        var expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
}

/*
 * function to read cookie
 *
 * @param name
 *
 */
function read_cookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ')
            c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0)
            return c.substring(nameEQ.length, c.length);
    }
    return null;
}

/*
 * function to get paramater from url
 *
 * @param name, url_string
 *
 */
function get_parameter(name, url_string) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(url_string);
    if (results == null) {
        return "";
    } else {
        return results[1];
    }
}