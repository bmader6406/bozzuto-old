module Analytics
  module DnrAndLeadChannel
    class RequestProcessor
      include Bozzuto::MiddlewareHelpers

      CTX_AD_SOURCE_COOKIE = '_bozzuto_dnr_ctx_ad_source'
      UTM_SOURCE_COOKIE    = '_bozzuto_dnr_utm_source'

      attr_reader :env
      attr_accessor :dnr_value, :lead_channel_value

      def initialize(env)
        @env = env
      end

      def process
        @write_cookies = false

        # if referrer is search engine and both params are present
        if referred_by_search_engine? && tsa_params_present?
          # use combined param value for Lead Channel
          self.lead_channel_value = combined_param_value

          # use utm_source param for DNR
          self.dnr_value = utm_source_param

          @write_cookies = true


        # else if saved cookies are present
        elsif tsa_cookies_present?
          # use combined cookie value for Lead Channel
          self.lead_channel_value = combined_cookie_value

          # use utm_source cookie for DNR
          self.dnr_value = utm_source_cookie


        # else if referrer is search engine and no params
        elsif referred_by_search_engine? && !ctx_ad_source_param_present?
          # use referrer for Lead Channel
          self.lead_channel_value = referrer_domain

          # use referrer for DNR
          self.dnr_value = referrer_domain


        else
          # use Bozzuto.com or Bozzuto.comMobile for Lead Channel
          self.lead_channel_value = mobile? ? 'Bozzuto.comMobile' : 'Bozzuto.com'

          # use existing logic for DNR
          self.dnr_value = nil
        end

        env['bozzuto.dnr']          = dnr_value
        env['bozzuto.lead_channel'] = lead_channel_value
      end

      def write_cookies(headers)
        if @write_cookies
          save_cookie(headers, CTX_AD_SOURCE_COOKIE, :value => ctx_ad_source_param, :expires => 30.days.from_now)
          save_cookie(headers, UTM_SOURCE_COOKIE, :value => utm_source_param, :expires => 30.days.from_now)
        end
      end


      private

      def referred_by_search_engine?
        referrer_domain.match(/(google|yahoo|bing)\.com$/).present?
      end

      # param values
      def tsa_params_present?
        ctx_ad_source_param_present? && utm_source_param_present?
      end

      def ctx_ad_source_param_present?
        ctx_ad_source_param.present?
      end

      def ctx_ad_source_param
        params['ctx_Ad Source']
      end

      def utm_source_param_present?
        utm_source_param.present?
      end

      def utm_source_param
        params['utm_source']
      end

      # cookie values
      def tsa_cookies_present?
        ctx_ad_source_cookie_present? && utm_source_cookie_present?
      end

      def ctx_ad_source_cookie_present?
        ctx_ad_source_cookie.present?
      end

      def ctx_ad_source_cookie
        cookies[CTX_AD_SOURCE_COOKIE]
      end

      def utm_source_cookie_present?
        utm_source_cookie.present?
      end

      def utm_source_cookie
        cookies[UTM_SOURCE_COOKIE]
      end

      # helpers
      def combined_tsa_value(ctx_ad_source, utm_source)
        "#{ctx_ad_source}-#{utm_source}"
      end

      def combined_param_value
        combined_tsa_value(ctx_ad_source_param, utm_source_param)
      end

      def combined_cookie_value
        combined_tsa_value(ctx_ad_source_cookie, utm_source_cookie)
      end

      def params
        @params ||= super
      end

      def cookies
        @cookies ||= super
      end

      def referrer_domain
        referrer_host || ''
      end
    end
  end
end
