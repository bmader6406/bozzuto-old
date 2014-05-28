module Bozzuto
  class PsiFeedLoader < ExternalFeedLoader
    self.feed_type = :psi
    self.tmp_file  = Rails.root.join('tmp', 'psi')
    self.lock_file = Rails.root.join('tmp', 'psi.lock')

    title                         './PropertyID/MarketingName'
    external_cms_id               './PropertyID/Identification/IDValue'
    street_address                './PropertyID/Address/Address'
    state                         './PropertyID/Address/State'
    city                          './PropertyID/Address/City'
    county                        './PropertyID/Address/CountyName'
    availability_url              './Information/PropertyAvailabilityURL'

    floor_plan_external_cms_id    './Identification/IDValue'
    floor_plan_name               './Name'
    floor_plan_comment            './Comment'
    floor_plan_availability_url   './FloorplanAvailabilityURL'
    floor_plan_available_units    './DisplayedUnitsAvailable'
    floor_plan_bedroom_count      './Room[@RoomType="Bedroom"]/Count'
    floor_plan_bathroom_count     './Room[@RoomType="Bathroom"]/Count'

    floor_plan_min_square_feet    './SquareFeet',    :attribute => 'Min'
    floor_plan_max_square_feet    './SquareFeet',    :attribute => 'Max'
    floor_plan_min_market_rent    './MarketRent',    :attribute => 'Min'
    floor_plan_max_market_rent    './MarketRent',    :attribute => 'Max'

    office_hour_open_time         './OpenTime'
    office_hour_close_time        './CloseTime'
    office_hour_day               './Day'

    private

    def when_floor_plans_present_for(property)
      if property.xpath('./Floorplan').any?
        yield
      end
    end

    def process_floor_plans(property)
      when_floor_plans_present_for property do
        rolled_up = rolled_up?(property)

        property.xpath('./Floorplan').each do |plan|
          attrs = floor_plan_attributes(plan)
          file  = plan.at('./File')

          attrs.merge!(
            :external_cms_file_id => (file['FileID'] rescue nil),
            :image_url            => (file.at('./Src').content rescue nil),
            :rolled_up            => rolled_up
          )

          create_or_update_floor_plan(attrs)
        end
      end
    end

    def floor_plan_attributes(plan)
      {
        :floor_plan_group   => floor_plan_group(plan),
        :name               => value_for(plan, :floor_plan_name),
        :availability_url   => value_for(plan, :floor_plan_availability_url),
        :available_units    => value_for(plan, :floor_plan_available_units).to_i,
        :bedrooms           => (value_for(plan, :floor_plan_bedroom_count) || 0).to_i,
        :bathrooms          => value_for(plan, :floor_plan_bathroom_count).to_f,
        :min_square_feet    => value_for(plan, :floor_plan_min_square_feet).to_i,
        :max_square_feet    => value_for(plan, :floor_plan_max_square_feet).to_i,
        :min_market_rent    => value_for(plan, :floor_plan_min_market_rent).to_f,
        :max_market_rent    => value_for(plan, :floor_plan_max_market_rent).to_f,
        :external_cms_id    => value_for(plan, :floor_plan_external_cms_id),
        :external_cms_type  => self.class.feed_type.to_s
      }
    end
  end
end
