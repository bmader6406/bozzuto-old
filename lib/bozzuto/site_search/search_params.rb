module Bozzuto
  module SiteSearch
    class SearchParams
      attr_reader :params

      def initialize(params = {})
        @params = params
      end

      def to_yboss_params
        {
          :q     => query.to_s,
          :sites => sites.to_s,
          :start => start.to_s,
          :count => per_page.to_s
        }
      end

      def query
        params[:q]
      end

      def sites
        params[:sites]
      end

      def start
        (page - 1) * per_page
      end

      def page
        [params[:page].to_i, 1].max
      end

      def per_page
        [params[:per_page].to_i, 20].max
      end
    end
  end
end
