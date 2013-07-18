require 'bozzuto/middleware_helpers'

module Bozzuto
  module Mobile
    class Middleware
      include Bozzuto::MiddlewareHelpers

      def initialize(app)
        @app = app
      end

      def call(env)
        @env = env

        check_for_full_site_flag
        detect_mobile

        @app.call(env)
      end


      private

      def check_for_full_site_flag
        if params['full_site'].present?
          session[:force_full_site] = params['full_site']
        end
      end

      def force_mobile?
        session[:force_full_site] == "0"
      end

      def force_browser?
        session[:force_full_site] == "1"
      end

      def detect_mobile
        self.device = user_agent.device

        if mobile_request?
          self.format = :mobile
        end
      end

      def mobile_request?
        (device != :browser && !force_browser?) || force_mobile?
      end

      def user_agent
        UserAgent.new(@env['HTTP_USER_AGENT'] || '')
      end

      def device
        @env['bozzuto.mobile.device']
      end

      def device=(new_device)
        @env['bozzuto.mobile.device'] = new_device
      end

      def format=(format)
        self.query_string = [query_string, "format=#{format}"].join('&')
      end
    end
  end
end
