module Analytics
  module AdSource
    class Middleware
      include Bozzuto::MiddlewareHelpers

      def initialize(app)
        @app = app
      end

      def call(env)
        @processor = RequestProcessor.new(env)

        @processor.process

        status, headers, body = @app.call(env)

        @processor.write_headers(headers)

        [status, headers, body]
      end

      class RequestProcessor
        include Bozzuto::MiddlewareHelpers

        AD_SOURCE_COOKIE = 'bozzuto_ad_source'


        attr_reader :env
        attr_accessor :ad_source

        def initialize(env)
          @env           = env
          @write_cookies = false
        end

        def process
          if ad_source_param.include?('-cheat')
            # From DNI v3 Documentation:
            # If Ctx_Ad Source Parameter is present in the url, and if its valus contains string “­cheat” then text
            # before ‘­cheat’ is set as ad source value and cookie(bozzuto_ad_source) is set.
            ad_source_value       = ad_source_param.match(/\A(?<value>.*)-cheat/)[:value]
            self.ad_source        = ad_source_value # Set Ad Source to the param minus '-cheat'
            self.ad_source_cookie = ad_source_value # Set cookie with the same value
          elsif ad_source_cookie.present?
            self.ad_source = ad_source_cookie # Set Ad Source to the cookie value
          elsif ad_source_param.present?
            self.ad_source        = ad_source_param # Set Ad Source to the param
            self.ad_source_cookie = ad_source_param # Save param in ad source cookie with 30 day expiry
          elsif matching_referrer.present?
            self.ad_source        = matching_referrer_ad_source # Set Ad Source to the matching DNR Referrer's value
            self.ad_source_cookie = matching_referrer_ad_source # Save DNR Referrer's value in ad source cookie with 30 day expiry
          else
            self.ad_source = "PropertyWebsite" # Otherwise, set Ad Source to PropertyWebsite
          end

          env['bozzuto.ad_source'] = ad_source
        end

        def write_headers(headers)
          if @write_headers
            save_cookie(headers, AD_SOURCE_COOKIE, value: @new_ad_source_cookie, expires: 30.days.from_now, path: '/')
          end
        end


        private

        def ad_source_cookie
          cookies[AD_SOURCE_COOKIE]
        end

        def ad_source_cookie=(value)
          @new_ad_source_cookie = value
          @write_headers        = true
        end

        def ad_source_param
          params['ctx_Ad Source']
        end

        def matching_referrer
          @matching_referrer ||= ::AdSource.matching(referrer_host)
        end

        def matching_referrer_ad_source
          matching_referrer.try(:value)
        end
      end
    end
  end
end
