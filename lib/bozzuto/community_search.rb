module Bozzuto
  class CommunitySearch
    attr_reader :params
    
    def initialize(params = {})
      @params = params
    end

    def results
      @results ||= query.all(:include => [:property_features, :city])
    end

    def query
      @query ||= ApartmentCommunity.published.featured_order.search(search_params)
    end

    def states
      @states ||= selected_state ? [selected_state] | states_by_result_count : states_by_result_count
    end
    
    def any_results?
      results.any?
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

    private

    def search_params
      @search_params ||= params.reject { |k, v| k == 'in_state' }
    end

    def selected_state
      @selected_state ||= State.find_by_id(params['in_state'])
    end

    def states_by_result_count
      @states_by_result_count ||= State.all.sort_by(&community_count).reverse
    end

    def community_count
      proc do |state|
        results_with(state: state).size
      end
    end
  end
end
