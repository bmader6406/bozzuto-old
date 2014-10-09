module Bozzuto
  module Neighborhoods
    class TierShuffler
      attr_reader :place, :communities, :tiers

      def initialize(options = {})
        @place       = options.fetch(:place)
        @communities = options.fetch(:communities, place.apartment_communities)
        @tiers       = Array(options.fetch(:tiers, "#{place.class}Membership::TIER".constantize))
      end

      def shuffled_communities_by_tier
        tiers.flat_map do |tier_number|
          tier(tier_number).shuffle
        end
      end

      private

      def tier(number)
        communities.select do |community|
          place.tier_for(community) == number
        end
      end
    end
  end
end
