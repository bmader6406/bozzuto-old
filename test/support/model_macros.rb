module Bozzuto
  module Test
    module ModelMacros
      def should_have_neighborhood_listing_image(name = :listing_image, opts = {})
        opts.reverse_merge!(:required => true)

        opts.assert_valid_keys(:required)

        should_have_attached_file(name)

        if opts[:required]
          should_validate_attachment_presence(name)
        end
      end

      def should_be_mappable
        should_validate_numericality_of(:latitude)
        should_validate_numericality_of(:longitude)
      end

      def should_have_apartment_floor_plan_cache
        should_have_one(:apartment_floor_plan_cache, :dependent => :destroy)
      end

      def should_have_one_seo_metadata
        should_have_one(:seo_metadata, :dependent => :destroy)
      end
    end
  end
end
