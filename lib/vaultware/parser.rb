module Vaultware
  class Parser
    attr_reader :data

    def parse(file)
      @data = Nokogiri::XML(File.read(file))
    end

    def process
      data.xpath('/PhysicalProperty/Property', ns).each do |property|
        process_property(property)
        process_floor_plan_groups(property.xpath('./Floorplan'))
      end
    end


    private

      def process_property(property)
        info = property.at('./PropertyID/ns:Identification', ns)
        address = property.at('./PropertyID/ns:Address', ns)

        @community = Community.find_or_initialize_by_vaultware_id(
          info.at('./ns:PrimaryID', ns).content.to_i
        )
        @community.update_attributes({
          :title          => info.at('./ns:MarketingName', ns).content,
          :website_url    => info.at('./ns:WebSite', ns).content,
          :street_address => address.at('./ns:Address1', ns).content,
          :city           => find_city(address)
        })
      end

      def process_floor_plan_groups(plans)
        @community.floor_plan_groups.destroy_all

        groups = plans.map do |group|
          group.at('./Comment').content
        end.uniq.sort

        groups.each do |group|
          @community.floor_plan_groups << FloorPlanGroup.new(:name => group)
        end
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

      def ns
        { 'ns' => 'http://my-company.com/namespace' }
      end

  end
end
