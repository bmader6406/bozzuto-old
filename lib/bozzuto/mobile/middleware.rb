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

        detect_full_site_flag
        detect_device

        @app.call(env)
      end


      private

      def detect_full_site_flag
        if params['full_site'].present?
          self.force_full_site = params['full_site']
        end
      end

      def detect_device
        self.device = user_agent.device
      end

      def user_agent
        UserAgent.new(@env['HTTP_USER_AGENT'] || '')
      end

      def device=(new_device)
        @env['bozzuto.mobile.device'] = new_device
      end

      def force_full_site=(new_value)
        @env['bozzuto.mobile.force_full_site'] = new_value
      end
    end
  end
end
