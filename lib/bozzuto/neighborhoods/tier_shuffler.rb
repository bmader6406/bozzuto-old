module Bozzuto
  module Neighborhoods
    class TierShuffler
      attr_reader :place, :communities

      def initialize(options = {})
        @place       = options.fetch(:place)
        @communities = options.fetch(:communities, place.apartment_communities)
      end

      def communities_in_tier(number)
        communities.select do |community|
          place.tier_for(community) == number
        end
      end

      def shuffled_communities_in_tier(number)
        communities_in_tier(number).shuffle
      end

      def shuffled_communities
        tiers.flat_map do |number|
          shuffled_communities_in_tier(number)
        end
      end

      private

      def tiers
        "#{place.class}Membership::TIER".constantize
      end
    end
  end
end
