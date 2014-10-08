module Bozzuto
  module Neighborhoods
    class Filterer
      attr_reader :place

      AMENITIES = [
        'Rapid Transit',
        'Non Smoking',
        'Pet Friendly',
        'Fitness Center',
        'Washer and Dryer'
      ]

      delegate :communities, :to => :place
      delegate :count,       :to => :communities

      def initialize(place, current_id)
        @place      = place
        @current_id = Integer(current_id) rescue nil
      end

      def amenities
        @amenities ||= AMENITIES.map { |name| PropertyFeature.find_by_name(name) }.compact
      end

      def current_amenity
        @current_amenity ||= amenities.detect { |a| a.id == @current_id }
      end

      def filters
        @filters ||= amenities.map { |a| Filter.new(self, a) }
      end

      def current_filter
        @current_filter ||= filters.detect { |f| f.amenity == current_amenity }
      end

      def filtered_communities
        result_set = if current_filter
          current_filter.communities
        else
          communities
        end

        TierShuffler.new(place, result_set).shuffled_communities_by_tier
      end

      class Filter
        attr_reader :amenity

        delegate :id, :name, :to => :amenity
        delegate :count,     :to => :communities

        def initialize(filterer, amenity)
          @filterer = filterer
          @amenity  = amenity
        end

        def communities
          @communities ||= @filterer.communities.with_property_features(id)
        end

        def name_with_count
          "#{name} (#{count})"
        end

        def current?
          @filterer.current_amenity == amenity
        end

        def any?
          count > 0
        end
      end

      class TierShuffler
        attr_reader :place, :communities

        def initialize(place, communities)
          @place       = place
          @communities = communities
        end

        def tiers
          "#{place.class}Membership::TIER".constantize
        end

        def tier(number)
          communities.select { |community| place.tier_for(community) == number }
        end

        def shuffled_communities_by_tier
          tiers.map { |tier_number| tier(tier_number).shuffle }.flatten
        end
      end
    end
  end
end
