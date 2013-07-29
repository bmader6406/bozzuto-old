module Analytics
  module DnrAndLeadChannel
    class Middleware
      include Bozzuto::MiddlewareHelpers

      def initialize(app)
        @app = app
      end

      def call(env)
        @processor = RequestProcessor.new(env)

        @processor.process

        status, headers, body = @app.call(env)

        @processor.write_cookies(headers)

        [status, headers, body]
      end
    end
  end
end
