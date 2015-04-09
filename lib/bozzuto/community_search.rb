module Bozzuto
  class CommunitySearch
    attr_reader :criteria

    def initialize(params = {})
      @criteria = Criteria.new(params)
    end

    def results
      matching_results.presence || relevant_results
    end

    def query
      @query ||= scope.search(criteria.without_location)
    end

    def states
      @states ||= criteria.state ? [criteria.state] | states_by_result_count : states_by_result_count
    end

    def showing_relevant_results?
      matching_results.none? && relevant_results.any?
    end

    def no_results?
      results.none?
    end

    def results_with(options)
      return [] unless options.present? && options.is_a?(Hash)

      results.select do |community|
        options.all? { |attr, value| community.send(attr) == value }
      end
    end

    def results_by_state
      @results_by_state ||= states.reduce(Hash.new) do |results, state|
        results.merge(state => results_with(state: state))
      end
    end

    def result_ids
      results.map(&:id)
    end

    private

    def scope
      ApartmentCommunity.published.featured_order
    end

    def include_features_and_city
      { :include => [:property_features, :city] }
    end

    def matching_results
      @matching_results ||= query.all(include_features_and_city)
    end

    def relevant_results
      @relevant_results ||= scope.search(criteria.adjusted_for_relevancy).all(include_features_and_city)
    end

    def states_by_result_count
      @states_by_result_count ||= State.all.sort_by(&community_count).reverse
    end

    def community_count
      proc do |state|
        results_with(state: state).size
      end
    end

    class Criteria < Struct.new(:params)
      STATE_CONDITION     = 'in_state'
      CITY_CONDITION      = 'city_id_eq'
      COUNTY_CONDITION    = 'county_id_eq'
      LOCATION_CONDITIONS = [STATE_CONDITION, CITY_CONDITION, COUNTY_CONDITION]
      BEDROOM_CONDITION   = 'with_floor_plan_groups'
      MIN_RENT_CONDITION  = 'with_min_price'
      MAX_RENT_CONDITION  = 'with_max_price'
      RENT_RELEVANCY      = 500
      BEDROOM_RELEVANCY   = 1

      def state
        @state ||= State.find_by_id(params[STATE_CONDITION])
      end

      def without_location
        params.reject { |k, v| LOCATION_CONDITIONS.include? k }
      end

      def adjusted_for_relevancy
        without_location
          .merge(relevant_min_rent)
          .merge(relevant_max_rent)
          .merge(relevant_bedrooms)
          .with_indifferent_access
      end

      private

      def min_rent
        @min_rent ||= params[MIN_RENT_CONDITION].to_f
      end

      def max_rent
        @max_rent ||= params[MAX_RENT_CONDITION].to_f
      end

      def bedrooms
        @bedrooms ||= params[BEDROOM_CONDITION].to_a.reject(&:empty?).map(&:to_i)
      end

      def relevant_min_rent
        if min_rent.zero?
          {}
        else
          { MIN_RENT_CONDITION => [min_rent - RENT_RELEVANCY, 0].max }
        end
      end

      def relevant_max_rent
        if max_rent.zero?
          {}
        else
          { MAX_RENT_CONDITION => max_rent + RENT_RELEVANCY }
        end
      end

      def smallest_floorplan
        if bedrooms.any?
          [bedrooms.min - BEDROOM_RELEVANCY, ApartmentFloorPlanGroup.studio.id].max
        end
      end

      def largest_floorplan
        if bedrooms.any?
          [bedrooms.max + BEDROOM_RELEVANCY, ApartmentFloorPlanGroup.penthouse.id].min
        end
      end

      def relevant_bedrooms
        if bedrooms.any?
          { BEDROOM_CONDITION => [*smallest_floorplan..largest_floorplan] }
        else
          {}
        end
      end
    end
  end
end
