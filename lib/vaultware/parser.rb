module Vaultware
  class Parser
    attr_reader :data

    def parse(file)
      @data = Nokogiri::XML(File.read(file))
    end

    def process
      data.xpath('/PhysicalProperty/Property', ns).each do |property|
        process_property(property)

        plans = property.xpath('./Floorplan')
        if aggregate_floor_plans?(plans)
          process_aggregate_floor_plans(plans)
        else
          process_single_floor_plans(plans)
        end
      end
    end


    private

    def process_property(property)
      ident   = property.at('./PropertyID/ns:Identification', ns)
      address = property.at('./PropertyID/ns:Address', ns)
      info    = property.at('./Information')

      @community = ApartmentCommunity.find_or_initialize_by_vaultware_id(
        ident.at('./ns:PrimaryID', ns).content.to_i
      )
      @community.update_attributes({
        :title            => ident.at('./ns:MarketingName', ns).content,
        :website_url      => ident.at('./ns:WebSite', ns).try(:content),
        :street_address   => address.at('./ns:Address1', ns).content,
        :city             => find_city(address),
        :county           => find_county(address),
        :availability_url => info.at('./PropertyAvailabilityURL').content
      })
    end

    def aggregate_floor_plans?(plans)
      plans.any? { |plan| plan.xpath('./File').count > 1 }
    end

    def process_aggregate_floor_plans(plans)
      @community.floor_plans.destroy_all

      plans.each do |plan|
        attrs = floor_plan_attributes(plan)
        files = plan.xpath('./File')

        if files.empty?
          @community.floor_plans << FloorPlan.new(attrs)
        else
          files.each do |file|
            @community.floor_plans << FloorPlan.new(attrs.merge(
              :image_url => file.at('./Src').try(:content)
            ))
          end
        end
      end
    end

    def process_single_floor_plans(plans)
      @community.floor_plans.destroy_all

      plans.each do |plan|
        attrs = floor_plan_attributes(plan)
        @community.floor_plans << FloorPlan.new(attrs.merge(
          :image_url => plan.at('./File/Src').try(:content)
        ))
      end
    end

    def floor_plan_group(plan)
      bedrooms = plan.at('./Room[@Type="Bedroom"]/Count').content.to_i

      if plan.at('./Comment').content =~ /penthouse/i
        FloorPlanGroup.penthouse
      elsif bedrooms == 0
        FloorPlanGroup.studio
      elsif bedrooms == 1
        FloorPlanGroup.one_bedroom
      elsif bedrooms == 2
        FloorPlanGroup.two_bedrooms
      else bedrooms == 3
        FloorPlanGroup.three_bedrooms
      end
    end

    def floor_plan_attributes(plan)
      {
        :floor_plan_group   => floor_plan_group(plan),
        :name               => plan.at('./Name').content,
        :availability_url   => plan.at('./FloorplanAvailabilityURL').content,
        :bedrooms           => plan.at('./Room[@Type="Bedroom"]/Count').content.to_i,
        :bathrooms          => plan.at('./Room[@Type="Bathroom"]/Count').content.to_f,
        :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
        :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
        :min_market_rent    => plan.at('./MarketRent')['Min'].to_f,
        :max_market_rent    => plan.at('./MarketRent')['Max'].to_f,
        :min_effective_rent => plan.at('./EffectiveRent')['Min'].to_f,
        :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f
      }
    end

    def find_city(address)
      state_code  = address.at('./ns:State', ns).content
      city_name   = address.at('./ns:City', ns).content
      county_name = address.at('./ns:CountyName', ns).content
      state       = State.find_by_code(state_code)

      city = state.cities.find_or_create_by_name(city_name)

      city
    end

    def find_county(address)
      state_code  = address.at('./ns:State', ns).content
      city_name   = address.at('./ns:City', ns).content
      county_name = address.at('./ns:CountyName', ns).content
      state       = State.find_by_code(state_code)

      city = state.cities.find_or_create_by_name(city_name)
      county = state.counties.find_or_create_by_name(county_name)

      unless city.counties.include?(county)
        city.counties << county
      end

      county
    end

    def ns
      { 'ns' => 'http://my-company.com/namespace' }
    end

  end
end
