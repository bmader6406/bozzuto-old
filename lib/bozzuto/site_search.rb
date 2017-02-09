module Bozzuto
  module SiteSearch
    def self.search(query, params = {})
      self::Algolia.search(query, params)
    end
  end
end
