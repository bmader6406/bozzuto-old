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
      @query ||= scope.search(criteria)
    end

    def location
      criteria.location.try(:record)
    end

    def states
      @states ||= if criteria.state
        showing_relevant_results? ? [criteria.state] | states_by_result_count : [criteria.state]
      else
        states_by_result_count
      end
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
      @states_by_result_count ||= State.all.sort_by(&community_count_proc).reverse
    end

    def community_count_proc
      proc do |state|
        results_with(state: state).size
      end
    end

    class Location < Struct.new(:model, :condition)
      attr_accessor :record

      def match(params)
        self.record = model.find_by(id: params[condition])
      end

      def state
        model == State ? record : record.try(:state)
      end
    end

    class Criteria < Hash
      BEDROOM_CONDITION           = 'having_all_floor_plan_groups'
      BEDROOM_RELEVANCY_CONDITION = 'with_any_floor_plan_groups'
      MIN_RENT_CONDITION          = 'with_min_price'
      MAX_RENT_CONDITION          = 'with_max_price'
      RENT_RELEVANCY              = 500

      def locations
        @locations ||= [
          Location.new(City, 'city_id_eq'),
          Location.new(County, 'county_id_eq'),
          Location.new(State, 'in_state')
        ]
      end

      def value_for(key)
        fetch(key, nil)
      end

      def state
        @state ||= location.try(:state)
      end

      def without_location
        reject { |k, v| locations.map(&:condition).include? k }
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

      def location
        @location ||= locations.find do |location|
          location.match(self)
        end
      end

      private

      def min_rent
        @min_rent ||= value_for(MIN_RENT_CONDITION).to_f
      end

      def max_rent
        @max_rent ||= value_for(MAX_RENT_CONDITION).to_f
      end
    end
  end
end
