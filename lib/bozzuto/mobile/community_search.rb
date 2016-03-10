module Bozzuto::Mobile
  class CommunitySearch
    ZIP_REGEX = /\A(?<zip>\d{5})(?:-\d{4})?\Z/

    attr_reader :search_type, :query, :results

    def self.search(query)
      if query =~ ZIP_REGEX
        matching_zip = ZipCode.find_by_zip($~[:zip])

        results = if matching_zip.present?
          zip_code_search_results_for zips_within_10_miles(matching_zip)
        end

        new(:zip, query, Array(results))
      else
        new(:name, query, {
          city:  Communities.search(city_name_start: query).result,
          title: Communities.search(title_cont: query).result
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
        results[:city] | results[:title]
      end
    end

    def type
      @type_inquirer ||= ActiveSupport::StringInquirer.new(search_type.to_s)
    end


    private

    def self.zips_within_10_miles(matching_zip)
      ZipCode.within(10, origin: matching_zip).by_distance(origin: matching_zip).select(:zip).map(&:zip)
    end

    def self.zip_code_search_results_for(zip_codes)
      Communities.search(:zip_code_start_any => zip_codes).result.sort_by do |community|
        zip_codes.index ZIP_REGEX.match(community.zip_code.strip)[:zip]
      end
    end

    class Communities
      CLASSES = [ApartmentCommunity, HomeCommunity]

      def self.search(conditions)
        ResultSet.new(CLASSES.map { |klass| klass.published.search(conditions) })
      end
    end

    class ResultSet < Struct.new(:queries)
      def result
        Array(queries).flat_map(&:result)
      end
    end
  end
end
