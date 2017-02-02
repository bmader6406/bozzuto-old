module Bozzuto
  module AlgoliaSiteSearch
    extend ActiveSupport::Concern

    included do
      include AlgoliaSearch
    end

    class_methods do
      def algolia_site_search(options = {}, &block)
        algoliasearch DEFAULT_ALGOLIA_OPTIONS.merge(options), &block
      end
    end

    def algolia_id
      "#{self.class.name}#{self.id}"
    end
  end
end
