module Vaultware
  class Parser
    attr_reader :data

    def parse(file)
      @data = Nokogiri::XML(File.read(file))
    end

    def process
      data.xpath('/PhysicalProperty/Property', ns).each do |property|
        process_property(property)

        property.xpath('./Floorplan').each do |plan|
          # Floorplan elements that have more than one File child
          # should be treated as separate floor plans, one for
          # each File
          if aggregate_floor_plan?(plan)
            process_aggregate_floor_plan(plan)
          else
            process_single_floor_plan(plan)
          end
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

    def aggregate_floor_plan?(plan)
      plan.xpath('./File').count > 1
    end

    def process_aggregate_floor_plan(plan)
      attrs = floor_plan_attributes(plan)
      files = plan.xpath('./File')

      # create one floor plan for each file
      files.each do |file|
        create_or_update_floor_plan(attrs.merge(
          :vaultware_file_id => file['Id'].to_i,
          :image_url => file.at('./Src').content
        ))
      end
    end

    def process_single_floor_plan(plan)
      attrs = floor_plan_attributes(plan)
      file = plan.at('./File')

      if file.present?
        attrs.merge!({
          :vaultware_file_id => file['Id'].to_i,
          :image_url         => file.at('./Src').content
        })
      end

      create_or_update_floor_plan(attrs)
    end

    def create_or_update_floor_plan(attrs)
      find_conditions = {
        :conditions => {
          :vaultware_floor_plan_id => attrs[:vaultware_floor_plan_id],
          :vaultware_file_id       => attrs[:vaultware_file_id]
        }
      }

      if plan = @community.floor_plans.find(:first, find_conditions)
        plan.update_attributes(attrs)
      else
        @community.floor_plans << ApartmentFloorPlan.new(attrs)
      end
    end

    def floor_plan_group(plan)
      bedrooms = plan.at('./Room[@Type="Bedroom"]/Count').content.to_i

      message = if plan.at('./Comment').content =~ /penthouse/i
        :penthouse
      elsif bedrooms == 0
        :studio
      elsif bedrooms == 1
        :one_bedroom
      elsif bedrooms == 2
        :two_bedrooms
      else bedrooms == 3
        :three_bedrooms
      end

      ApartmentFloorPlanGroup.send(message)
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
        :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f,
        :vaultware_floor_plan_id => plan['Id'].to_i
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
