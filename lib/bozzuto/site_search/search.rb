module Bozzuto
  module SiteSearch
    class Search
      attr_reader :query, :params

      def initialize(query, params = {})
        @query  = query
        @params = params
      end

      def results
        @results ||= search.result.order(:title).per_page_kaminari(page).per(per_page)
      end

      def search
        @search = ApartmentCommunity.includes(:city).search(
          title_cont: query,
          city_name_cont: query,
          zip_code_cont: query,
          listing_text_cont: query,
          neighborhood_listing_description_cont: query,
          overview_text: query,
          m: 'or'
        )
      end

      def per_page
        (params[:per_page] || 20).to_i
      end

      def page
        (params[:page] || 1).to_i
      end

      def total_count
        results.total_count
      end

      def first_result_num
        (page * per_page) - per_page + 1
      end

      def last_result_num
        [page * per_page, total_count].min
      end
    end
  end
end
