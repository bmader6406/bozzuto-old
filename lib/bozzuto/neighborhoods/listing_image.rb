module Bozzuto
  module Neighborhoods
    module ListingImage
      def has_neighborhood_listing_image(name = :listing_image, opts = {})
        opts.reverse_merge!(:required => true)

        opts.assert_valid_keys(:required)

        has_attached_file(name,
                          :url             => '/system/:class/:id/:attachment_name/:style.:extension',
                          :styles          => { :resized => '300x234#' },
                          :default_style   => :resized,
                          :convert_options => { :all => '-quality 80 -strip' })

        if opts[:required]
          validates_attachment_presence(name)
        end
      end
    end
  end
end
