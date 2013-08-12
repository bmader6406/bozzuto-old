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

        AD_SOURCE_COOKIE = '_bozzuto_ad_source'

        attr_reader :env
        attr_accessor :lead_channel_value, :dnr_value

        def initialize(env)
          @env           = env
          @write_cookies = false
        end

        def process
          if ad_source_cookie.present?
            # Set DNR Ad Source to the cookie value
            self.dnr_value = ad_source_cookie

            # Set Lead Channel to the cookie value
            self.lead_channel_value = ad_source_cookie


          elsif ad_source_param.present?
            # Set DNR Ad Source to the cookie value
            self.dnr_value = ad_source_param

            # Set Lead Channel to the cookie value
            self.lead_channel_value = ad_source_param

            # Save the param value in the ad source cookie, to expire in 30 days
            self.ad_source_cookie = ad_source_param


          elsif matching_referrer.present?
            # Set DNR Ad Source to the matching DNR Referrer's value
            self.dnr_value = matching_referrer_ad_source

            # Set Lead Channel to the matching DNR Referrer's value
            self.lead_channel_value = matching_referrer_ad_source

            # Save the matching DNR Referrer's value in the ad source cookie, to expire in 30 days
            self.ad_source_cookie = matching_referrer_ad_source


          else
            # Set DNR Ad Source to nil
            self.dnr_value = nil

            # Set Lead Channel to Bozzuto.com or Bozzuto.comMobile
            self.lead_channel_value = mobile? ? 'Bozzuto.comMobile' : 'Bozzuto.com'

          end

          env['bozzuto.ad_source.dnr']          = dnr_value
          env['bozzuto.ad_source.lead_channel'] = lead_channel_value
        end

        def write_headers(headers)
          if @write_headers
            save_cookie(headers, AD_SOURCE_COOKIE, :value => @new_ad_source_cookie, :expires => 30.days.from_now)
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
