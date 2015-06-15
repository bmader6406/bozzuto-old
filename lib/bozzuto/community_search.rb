module Bozzuto
  class CommunitySearch
    attr_reader :criteria

    def initialize(params = {})
      @criteria = Criteria.new.merge(params)
    end

    def results
      matching_results.presence || relevant_results
    end

    def query
      @query ||= scope.search(criteria.without_location)
    end

    def states
      @states ||= if criteria.state
        [criteria.state] | states_by_result_count
      else
        states_by_result_count
      end
    end

    def showing_relevant_results?
      if criteria.state.present?
        matching_results.select(&matching_location_proc).none? && relevant_results.any?
      else
        matching_results.none? && relevant_results.any?
      end
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
      @states_by_result_count ||= State.all.sort_by(&community_count_proc).reverse
    end

    def community_count_proc
      proc do |state|
        results_with(state: state).size
      end
    end

    def matching_location_proc
      proc do |community|
        community.state == criteria.state if community.state.present?
      end
    end

    class Criteria < Hash
      STATE_CONDITION             = 'in_state'
      CITY_CONDITION              = 'city_id_eq'
      COUNTY_CONDITION            = 'county_id_eq'
      LOCATION_CONDITIONS         = [STATE_CONDITION, CITY_CONDITION, COUNTY_CONDITION]
      BEDROOM_CONDITION           = 'having_all_floor_plan_groups'
      BEDROOM_RELEVANCY_CONDITION = 'with_any_floor_plan_groups'
      MIN_RENT_CONDITION          = 'with_min_price'
      MAX_RENT_CONDITION          = 'with_max_price'
      RENT_RELEVANCY              = 500

      def value_for(key)
        fetch(key, nil)
      end

      def state
        @state ||= State.find_by_id value_for(STATE_CONDITION)
      end

      def without_location
        reject { |k, v| LOCATION_CONDITIONS.include? k }
      end

      def adjusted_for_relevancy
        without_location
          .matching_any_bedroom_condition
          .with_relevant_min_rent
          .with_relevant_max_rent
          .with_indifferent_access
      end

      def matching_any_bedroom_condition
        merge BEDROOM_RELEVANCY_CONDITION => delete(BEDROOM_CONDITION)
      end

      def with_relevant_min_rent
        if min_rent.zero?
          self
        else
          merge MIN_RENT_CONDITION => [min_rent - RENT_RELEVANCY, 0].max
        end
      end

      def with_relevant_max_rent
        if max_rent.zero?
          self
        else
          merge MAX_RENT_CONDITION => max_rent + RENT_RELEVANCY
        end
      end

      private

      def min_rent
        @min_rent ||= value_for(MIN_RENT_CONDITION).to_f
      end

      def max_rent
        @max_rent ||= value_for(MAX_RENT_CONDITION).to_f
      end

      def bedrooms
        @bedrooms ||= value_for(BEDROOM_CONDITION).to_a.reject(&:empty?).map(&:to_i)
      end
    end
  end
end
