module Bozzuto
  module SiteSearch
    def self.search(query, params = {})
      SearchResultProxy.for_query(query).first.try(:url) ||
        self::Algolia.search(*modify_query(query, params))
    end

    def self.modify_query(query, params)
      ActsAsTaggableOn::Tag.pluck("DISTINCT(tags.name)").each do |tag|
        if query.downcase.include?(tag.downcase)
          query = query.gsub(/#{tag}/i, '')
          params[:tagFilters] ||= []
          params[:tagFilters] << tag
        end
      end
      return query, params
    end
  end
end
