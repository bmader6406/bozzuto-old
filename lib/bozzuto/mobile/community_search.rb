module Bozzuto::Mobile
  class CommunitySearch
    ZIP_REGEX = /\A(?<zip>\d{5})(?:-\d{4})?\Z/

    attr_reader :search_type, :query, :results

    def self.search(query)
      load_community_classes

      if query =~ ZIP_REGEX
        matching_zip = ZipCode.find_by_zip($~[:zip])

        results = if matching_zip.present?
          zip_code_search_results_for zips_within_10_miles(matching_zip)
        end

        new(:zip, query, Array(results))
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

    def self.zips_within_10_miles(matching_zip)
      ZipCode.within(10, origin: matching_zip).by_distance(origin: matching_zip).select(:zip).map(&:zip)
    end

    def self.zip_code_search_results_for(zip_codes)
      base_scope.search(:zip_code_starts_with_any => zip_codes).all.sort_by do |community|
        zip_codes.index ZIP_REGEX.match(community.zip_code.strip)[:zip]
      end
    end
  end
end
