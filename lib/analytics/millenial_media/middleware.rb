module Analytics
  module MillenialMedia
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @env = env

        if mmurid.present?
          session[:mmurid] = mmurid
        end

        @app.call(env)
      end

      private

      def session
        @env['rack.session']
      end

      def params
        Rack::Utils.parse_query(@env['QUERY_STRING'])
      end

      def mmurid
        params['mmurid']
      end
    end
  end
end
