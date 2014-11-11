module Bozzuto
  module Neighborhoods
    module Slideshow
      def tier_1_community_slides
        return [] unless apartment_communities.any?

        @tier_1_community_slides ||= shuffled_communities.map do |community|
          Slide.new(community)
        end
      end

      class Slide < Struct.new(:community)
        delegate :title, :to => :community

        # :nocov:
        def image
          community.hero_image
        end
        # :nocov:
      end

      private

      def shuffled_communities
        TierShuffler.new(
          :place       => self,
          :communities => communities_with_hero_images,
        ).shuffled_communities_in_tier(1)
      end

      def communities_with_hero_images
        apartment_communities.where('hero_image_file_name IS NOT NULL')
      end
    end
  end
end
