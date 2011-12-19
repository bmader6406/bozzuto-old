module Bozzuto
  class WwwRedirector
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env

      if env['HTTP_HOST'] !~ /^www\./
        [301, { 'Location' => url, 'Content-Type' => 'text/html' }, '']
      else
        @app.call(env)
      end
    end

    def url
      "#{protocol}://#{host}#{path}"
    end

    def protocol
      @env['rack.url_scheme']
    end

    def host
      "www.#{@env['HTTP_HOST']}"
    end

    def path
      @env['PATH_INFO']
    end
  end
end
