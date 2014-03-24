module Bozzuto
  module Neighborhoods
    module ListingImage
      def self.extended(base)
        base.class_eval do
          has_attached_file :listing_image,
                            :url             => '/system/:class/:id/:style.:extension',
                            :styles          => { :resized => '300x234#' },
                            :default_style   => :resized,
                            :convert_options => { :all => '-quality 80 -strip' }

          validates_attachment_presence :listing_image
        end
      end
    end
  end
end
