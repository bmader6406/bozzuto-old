module Bozzuto
  module Neighborhoods
    class TierShuffler
      attr_reader :place, :communities

      def initialize(options = {})
        @place       = options.fetch(:place)
        @communities = options.fetch(:communities, place.apartment_communities)
      end

      def shuffled_communities_by_tier
        tiers.flat_map do |tier_number|
          tier(tier_number).shuffle
        end
      end

      private

      def tiers
        "#{place.class}Membership::TIER".constantize
      end

      def tier(number)
        communities.select do |community|
          place.tier_for(community) == number
        end
      end
    end
  end
end
