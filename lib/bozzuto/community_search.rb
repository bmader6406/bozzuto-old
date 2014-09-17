module Bozzuto
  class CommunitySearch
    attr_reader :search_type, :query, :results
    
    def self.search(query)
      load_community_classes

      if query =~ /\A\d{5}(?:-\d{4})?\Z/
        new(:zip, query, base_scope.search(:zip_code_starts_with => query).all)
      else
        new(:name, query, {
          :city  => base_scope.search(:city_name_starts_with => query).all,
          :title => base_scope.search(:title_contains => query).all
        })
      end
    end
    
    def initialize(search_type, query, results)
      @search_type = search_type
      @query = query
      @results = results
    end
    
    def total_results_count
      all_results.size
    end
    
    def results?
      all_results.size > 0
    end
    
    def all_results
      if search_type == :zip
        results
      else
        (results[:city] + results[:title]).uniq
      end
    end
    
    def type
      @type_inquirer ||= ActiveSupport::StringInquirer.new(search_type.to_s)
    end
    

    private

    def self.base_scope
      Community.published
    end
    
    def self.load_community_classes
      ApartmentCommunity
      HomeCommunity
    end
  end
end
