module Bozzuto
  module MiddlewareHelpers
    def referrer
      @env['HTTP_REFERER']
    end

    def referrer_host
      URI.parse(referrer).host
    rescue URI::InvalidURIError
      nil
    end

    def params
      Rack::Utils.parse_query(query_string)
    end

    def cookies
      Rack::Request.new(@env).cookies
    end

    def save_cookie(headers, key, value)
      Rack::Utils.set_cookie_header!(headers, key, value)
    end

    def session
      @env['rack.session']
    end

    def query_string
      @env['QUERY_STRING']
    end

    def mobile?
      env['bozzuto.mobile.device'].present? && env['bozzuto.mobile.device'] != :browser
    end
  end
end
