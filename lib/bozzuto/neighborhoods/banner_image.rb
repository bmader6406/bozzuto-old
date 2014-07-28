module Bozzuto
  module Neighborhoods
    module BannerImage
      def has_neighborhood_banner_image(opts = {})
        name     = opts.fetch(:name, :banner_image)
        required = opts.fetch(:required, true)

        has_attached_file(name,
                          :url             => '/system/:class/:id/:attachment_name/:style.:extension',
                          :styles          => { :resized => '1020x325#' },
                          :default_style   => :resized,
                          :convert_options => { :all => '-quality 80 -strip' })

        if required
          validates_attachment_presence(name)
        end
      end
    end
  end
end