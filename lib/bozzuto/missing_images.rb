module Bozzuto
  class MissingImages
    def initialize(app)
      @app         = app
      @image_regex = /\.(jpe?g|png|gif|bmp)$/i
    end

    def call(env)
      if env['PATH_INFO'] =~ @image_regex
        [404, { 'Content-Type' => 'text/html' }, 'Image not found']
      else
        @app.call(env)
      end
    end
  end
end
