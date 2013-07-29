var backwardsCompatible = false; // leaving true fixes IE cookie problem in old version
                                 // setting to false improves performance of new version
var urlOverridesFunction = false;  // Set to true for URL arguments to override replaceNumber arguments
                                   // Set to false if replaceNumber should override URL arguments
var callsourceServer = 'reporting.callsource.com'; // for production
//var callsourceServer = 'budev08.callsource.com'; // uncomment and edit for testing
var referrerString = document.referrer;
var referrerHost = (referrerString.split('/'))[2]; // for production
//var referrerHost = 'CMN'; // uncomment and edit for testing
var urlString = window.location.href;
var thisHost = (urlString.split('/'))[2];
// get parameters from url
var accountParam = getParameter("ctd_ac", urlString);
var customerParam = getParameter("ctd_co", urlString);
var campaignParam = getParameter("ctx_name", urlString);
var adsourceParam = getParameter("ct_Ad%20Source", urlString);
if (adsourceParam.length == 0) {
  adsourceParam = getParameter("ctx_Ad%20Source", urlString);
}
if (adsourceParam.length == 0) {
  adsourceParam = getParameter("ct_Ad\\+Source", urlString);
}
if (adsourceParam.length == 0) {
  adsourceParam = getParameter("ctx_Ad\\+Source", urlString);
}

if (referrerHost != null && thisHost.indexOf(referrerHost) == -1 && referrerHost.indexOf('undefined') == -1) {
    createCookie("ReferrerHost", referrerHost, "3600");
} else {
    referrerHost = readCookie("ReferrerHost");
}
// alert (referrerHost); // uncomment to test persistence of referrer

// Check for parameters in URL.
if (urlString.indexOf("ctd_ac") > -1) {
    var cookieValue = readCookie("CTTrackRef");
    // Create cookie of it does not exist.
    if (cookieValue == null) {
        createCookie("CTTrackRef", urlString, "3600");
    } else {
        cookieQueryString = (cookieValue.split("?"))[1];
        thisQueryString = (urlString.split("?"))[1];
        // Create new cookie if the current parameters are different
        // from the saved parameters.
        if (thisQueryString.indexOf(cookieQueryString) == -1) {
            createCookie("CTTrackRef", urlString, "3600");
        }
    }
// If paramemters are not present, check for a cookie.
} else {
    var cookieValue = readCookie("CTTrackRef");
    if (cookieValue != null) {
        var queryString = (cookieValue.split("?"))[1];
        if (queryString != null) {
            var redirectURL;
            if (urlString.indexOf('?') > -1) {
                // Preserve other parameters in current URL.
                redirectURL = urlString+'&'+queryString;
            } else {
                // No other parameters are present in current URL.
                redirectURL = urlString+'?'+queryString;
            }
            if (window.ActiveXObject && backwardsCompatible) {
                // This is for the IE cookie problem in the old version
                window.location = redirectURL;
            } else {
                accountParam = getParameter("ctd_ac", redirectURL);
                customerParam = getParameter("ctd_co", redirectURL);
                campaignParam = getParameter("ctx_name", redirectURL);
                adsourceParam = getParameter("ct_Ad%20Source", redirectURL);
                if (adsourceParam.length == 0) {
                    adsourceParam = getParameter("ctx_Ad%20Source", redirectURL);
                }
                if (adsourceParam.length == 0) {
                    adsourceParam = getParameter("ct_Ad\\+Source", redirectURL);
                }
                if (adsourceParam.length == 0) {
                    adsourceParam = getParameter("ctx_Ad\\+Source", redirectURL);
                }
            }
        }
    }
}

function createCookie(name,value,seconds) {
    if (seconds) {
        var date = new Date();
        date.setTime(date.getTime()+(seconds*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function getParameter(name, urlString) {
    name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
    var regexS = "[\\?&]"+name+"=([^&#]*)";
    var regex = new RegExp( regexS );
    var results = regex.exec(urlString);
    if( results == null ) {
        return "";
    } else {
        return results[1];
    }
}

var frameWidth = 150;
var frameHeight = 17;

function setSize(width, height) {
    frameWidth = width;
    frameHeight = height;
}

function replaceNumber(numberToReplace, format, account, customer, campaign, adsource) {
    //use parameters from url if given:
    if (urlOverridesFunction) {
        if (accountParam.length > 0) {
            account = accountParam;
        }
        if (customerParam.length > 0) {
            customer = customerParam;
        }
        if (campaignParam.length > 0) {
            campaign = campaignParam;
        }
        if (adsourceParam.length > 0) {
            adsource = adsourceParam;
        }
    }
    else {
        if ((account == null || account == "undefined") && accountParam.length > 0) {
            account = accountParam;
        }
        if ((customer == null || customer == "undefined") && customerParam.length > 0) {
            customer = customerParam;
        }
        if ((campaign == null || campaign == "undefined") && campaignParam.length > 0) {
            campaign = campaignParam;
        }
        if ((adsource == null || adsource == "undefined") && adsourceParam.length > 0) {
            adsource = adsourceParam;
        }
    }
    // set defaults
    if (format == null || format == "undefined") {
        format = '(xxx) xxx-xxxx';
    }
    if (campaign == null) {
        campaign = 'undefined';
    }
    if (adsource == null) {
        adsource = 'undefined';
    }
    // get style information by getting current script tag object
    var scriptTags = document.getElementsByTagName('script');
    var scriptTag = scriptTags[scriptTags.length - 1];
    var textcolor = getHex(getStyle(scriptTag, 'color'));
    var fontfamily = getStyle(scriptTag, 'font-family');
    if (fontfamily == null) {
        fontfamily = getStyle(scriptTag, 'fontFamily');
    }
    var fontsize = getStyle(scriptTag, 'font-size');
    if (fontsize == null) {
        fontsize = getStyle(scriptTag, 'fontSize');
    }
    var fontstyle = getStyle(scriptTag, 'font-style');
    if (fontstyle == null) {
        fontstyle = getStyle(scriptTag, 'fontStyle');
    }
    var fontweight = getStyle(scriptTag, 'font-weight');
    if (fontweight == null) {
        fontweight = getStyle(scriptTag, 'fontWeight');
    }
    var servletRequest = 'http://'+callsourceServer+'/simplelookup/Lookup?ctd_ac='+account+'&ctd_co='+customer+'&ctx_name='+campaign+'&ct_Ad%20Source='+adsource+'&fmt='+format+'&number='+numberToReplace+'&referrer='+referrerHost+'&textcolor='+textcolor+'&fontfamily='+fontfamily+'&fontsize='+fontsize+'&fontstyle='+fontstyle+'&fontweight='+fontweight;
    servletRequest = encodeUrl(servletRequest);
    var iframe = '<iframe allowtransparency="true" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" width="'+frameWidth+'" height="'+frameHeight+'" src="'+servletRequest+'"></iframe>';
    //document.write(iframe);
    return iframe;
}

function getStyle(element, property) {
    if (element.currentStyle) {
        var value = element.currentStyle[property];
    } else if (window.getComputedStyle) {
        var value = document.defaultView.getComputedStyle(element,null).getPropertyValue(property);
    }
    return value;
}

function getHex(color) {
    if (color.indexOf('rgb') > -1) { // Mozilla in rgb(255, 255, 255) format
        var rgbcolor = ((color.split("("))[1].split(")"))[0].split(",");
        var red = rgbcolor[0];
        var green = rgbcolor[1];
        var blue = rgbcolor[2];
        return RGBtoHex(red, green, blue);
    } else { // IE already hex or color word
        if (color.indexOf('#') == 0)
            color = color.substring(1);
        return color;
    }
}

function RGBtoHex(R,G,B) {
    return toHex(R)+toHex(G)+toHex(B)
}

function toHex(N) {
    if (N==null) return "00";
    N=parseInt(N);
    if (N==0 || isNaN(N))
        return "00";
    N=Math.max(0,N);
    N=Math.min(N,255);
    N=Math.round(N);
    return "0123456789ABCDEF".charAt((N-N%16)/16)
      + "0123456789ABCDEF".charAt(N%16);
}

function encodeUrl(url) {
    if (url.indexOf("?")>0) {
        encodedParams = "?";
        parts = url.split("?");
        params = parts[1].split("&");
        for(i = 0; i < params.length; i++) {
            if (i > 0) {
                encodedParams += "&"; 
            }
            if (params[i].indexOf("=")>0) { //Avoid null values
                p = params[i].split("=");
                encodedParams += (p[0] + "=" + escape(encodeURI(p[1])));
            } else  {
                encodedParams += params[i];
            }
        }
        url = parts[0] + encodedParams;
    }
    return url;
}

