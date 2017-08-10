require 'bozzuto/middleware_helpers'

module Analytics
  module MillenialMedia
    class Middleware
      include Bozzuto::MiddlewareHelpers

      def initialize(app)
        @app = app
      end

      def call(env)
        @env = env

        if mmurid.present? && CookiesController::CHECK_IF_ENABLED[cookies]
          session[:mmurid] = mmurid
        end

        @app.call(env)
      end


      private

      def mmurid
        params['mmurid']
      end
    end
  end
end
