module Bozzuto
  module SiteSearch
    def self.search(query, params = {})
      Search.new(query, params)
    end
  end
end
