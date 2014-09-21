module Bozzuto
  module SiteSearch
    class Search
      attr_reader :query, :params

      def initialize(query, params = {})
        params.delete(:sites)

        @query = query
        @params = params.reverse_merge!(
          :q        => query,
          :per_page => 20,
          :sites    => 'bozzuto.com'
        )
      end

      def search_params
        @search_params ||= SearchParams.new(params)
      end

      def yboss
        @yboss ||= YBoss.web(search_params.to_yboss_params)
      end

      def results
        yboss.items
      end

      def start
        yboss.start.to_i
      end

      def count
        yboss.count.to_i
      end
      alias_method :per_page, :count

      def page
        (start / per_page) + 1
      end

      def total_pages
        [(total_results.to_f / per_page).ceil, 50].min
      end

      def total_results
        yboss.totalresults.to_i
      end

      def first_result_num
        start + 1
      end

      def last_result_num
        start + per_page
      end
    end
  end
end
