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
        process_floor_plans(property.xpath('./Floorplan'))
      end
    end


    private

    def process_property(property)
      ident   = property.at('./PropertyID/ns:Identification', ns)
      address = property.at('./PropertyID/ns:Address', ns)
      info    = property.at('./Information')

      @community = Community.find_or_initialize_by_vaultware_id(
        ident.at('./ns:PrimaryID', ns).content.to_i
      )
      @community.update_attributes({
        :title            => ident.at('./ns:MarketingName', ns).content,
        :website_url      => ident.at('./ns:WebSite', ns).try(:content),
        :street_address   => address.at('./ns:Address1', ns).content,
        :city             => find_city(address),
        :availability_url => info.at('./PropertyAvailabilityURL').content
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

    def process_floor_plans(plans)
      plans.each do |plan|
        group = @community.floor_plan_groups.find_by_name(plan.at('./Comment').content)

        group.floor_plans << FloorPlan.new(
          :name               => plan.at('./Name').content,
          :availability_url   => plan.at('./FloorplanAvailabilityURL').content,
          :bedrooms           => plan.at('./Room[@Type="Bedroom"]/Count').content.to_i,
          :bathrooms          => plan.at('./Room[@Type="Bathroom"]/Count').content.to_f,
          :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
          :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
          :min_market_rent    => plan.at('./MarketRent')['Min'].to_f,
          :max_market_rent    => plan.at('./MarketRent')['Max'].to_f,
          :min_effective_rent => plan.at('./EffectiveRent')['Min'].to_f,
          :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f,
          :image              => plan.at('./File/Src').try(:content)
        )
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
