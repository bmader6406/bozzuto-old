module Bozzuto
  module MiddlewareHelpers
    def params
      Rack::Utils.parse_query(query_string)
    end

    def session
      @env['rack.session']
    end

    def query_string
      @env['QUERY_STRING']
    end

    def query_string=(new_query_string)
      @env['QUERY_STRING'] = new_query_string
    end
  end
end
