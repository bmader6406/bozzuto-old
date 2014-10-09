module Bozzuto
  module Neighborhoods
    module Slideshow
      def slides
        return [] unless apartment_communities.any?

        @slides ||= TierShuffler.new(:place => self, :tiers => 1).shuffled_communities_by_tier.map do |community|
          Slide.new(community)
        end
      end

      class Slide < Struct.new(:community)
        delegate :title, :to => :community

        def image
          community.hero_image
        end
      end
    end
  end
end
