module Vaultware
  class Parser
    attr_reader :data

    def parse(file)
      @data = Nokogiri::XML(File.read(file))

      process_data
    end


    private

      def process_data
        data.xpath('/PhysicalProperty/Property', ns).each do |property|
          process_property(property)
        end
      end

      def process_property(property)
        info = property.at('./PropertyID/ns:Identification', ns)
        address = property.at('./PropertyID/ns:Address', ns)

        community = Community.create({
          :title          => info.at('./ns:MarketingName', ns).content,
          :website_url    => info.at('./ns:WebSite', ns).content,
          :street_address => address.at('./ns:Address1', ns).content,
          :city           => find_city(address),
          :vaultware_id   => info.at('./ns:PrimaryID', ns).content.to_i
        })
      end

      def ns
        { 'ns' => 'http://my-company.com/namespace' }
      end

      def find_city(address)
        state_code  = address.at('./ns:State', ns).content
        city_name   = address.at('./ns:City', ns).content
        county_name = address.at('./ns:CountyName', ns).content

        # TODO: create the county if it doesn't exist?
        state = State.find_by_code(state_code)
        city  = state.cities.find_by_name(city_name)

        city || City.create(:name => city_name, :state => state)
      end
  end
end
