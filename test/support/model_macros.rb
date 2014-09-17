module Bozzuto
  module Test
    module ModelMacros
      def should_have_neighborhood_listing_image(name = :listing_image, opts = {})
        opts.reverse_merge!(:required => true)

        opts.assert_valid_keys(:required)

        should have_attached_file(name)

        if opts[:required]
          should validate_attachment_presence(name)
        end
      end

      def should_have_neighborhood_banner_image(opts = {})
        name     = opts.fetch(:name, :banner_image)
        required = opts.fetch(:required, true)

        should have_attached_file(name)

        if required
          should validate_attachment_presence(name)
        end
      end

      def should_be_mappable
        should validate_numericality_of(:latitude)
        should validate_numericality_of(:longitude)
      end

      def should_have_apartment_floor_plan_cache
        should have_one(:apartment_floor_plan_cache).dependent(:destroy)
      end

      def should_have_seo_metadata
        should have_one(:seo_metadata).dependent(:destroy)
      end
    end
  end
end
