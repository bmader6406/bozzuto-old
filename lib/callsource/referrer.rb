module Callsource
  module Referrer
    # The Callsource dynamic number replacement (DNR) JavaScript embed takes a referrer parameter that lets
    # Callsource track what site a user came from. This code pulls the referrer, matches it against a
    # whitelist of referrers to track, and then saves it in a cookie for 30 days after the user's most
    # recent visit.
    def self.included(base)
      base.class_eval do
        helper_method :referrer_host
        helper_method :dnr_referrer

        before_filter :save_referrer_for_dnr
      end
    end

    DNR_COOKIE = '_dnr_referrer'

    def referrer_host
      URI.parse(request.referrer).host
    rescue URI::InvalidURIError
      nil
    end

    def dnr_referrer_matching_host
      DnrReferrer.matching(referrer_host)
    end

    def dnr_referrer
      cookies[DNR_COOKIE]
    end

    def save_referrer_for_dnr
      referrer = dnr_referrer_matching_host

      if referrer
        # Matched a new referrer, save it
        set_dnr_cookie(referrer)
      elsif cookies[DNR_COOKIE].present?
        # No match but a previous match is saved, update the expiration date
        set_dnr_cookie(cookies[DNR_COOKIE])
      else
        # No match and no previous match to update, do nothing
      end
    end

    def set_dnr_cookie(referrer)
      cookies[DNR_COOKIE] = {
        :value   => referrer,
        :expires => 30.days.from_now
      }
    end
  end
end
