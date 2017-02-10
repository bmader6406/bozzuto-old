module Bozzuto
  module SiteSearch
    def self.search(query, params = {})
      SearchResultProxy.for_query(query).first.try(:url) ||
        self::Algolia.search(query, params)
    end
  end
end
