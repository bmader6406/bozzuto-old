module Analytics
  module Dnr
    module Referrer
      # The Callsource dynamic number replacement (DNR) JavaScript embed takes a referrer parameter that lets
      # Callsource track what site a user came from. This code pulls the referrer, matches it against a
      # whitelist of referrers to track, and then saves it in a cookie for 30 days after the user's most
      # recent visit.
      class Middleware
        include Bozzuto::MiddlewareHelpers

        DNR_COOKIE = '_dnr_cookie'

        def initialize(app)
          @app = app
        end

        def call(env)
          @env = env

          save_referrer_for_dnr

          status, headers, body = @app.call(env)

          set_dnr_cookie(headers)

          [status, headers, body]
        end


        private

        def value_already_present?
          @value_already_present
        end

        def dnr_referrer_matching_host
          ::DnrReferrer.matching(referrer_host)
        end

        def save_referrer_for_dnr
          if @env['bozzuto.dnr'].present?
            @value_already_present = true
          else
            @value_already_present = false
            @env['bozzuto.dnr'] = dnr_referrer_matching_host
          end
        end

        def set_dnr_cookie(headers)
          if !value_already_present? && @env['bozzuto.dnr']
            # Matched a new referrer, save it
            save_cookie(headers, DNR_COOKIE, :value => @env['bozzuto.dnr'], :expires => 30.days.from_now)

          elsif cookies[DNR_COOKIE].present?
            # No match but a previous match is saved, update the expiration date
            save_cookie(headers, DNR_COOKIE, :value => cookies[DNR_COOKIE], :expires => 30.days.from_now)

          else
            # No match and no previous match to update, do nothing
          end
        end
      end
    end
  end
end
