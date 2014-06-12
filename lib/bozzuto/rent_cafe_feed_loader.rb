module Bozzuto
  class RentCafeFeedLoader < ExternalFeedLoader
    self.feed_type = :rent_cafe
    self.tmp_file  = Rails.root.join('tmp', 'rent_cafe')
    self.lock_file = Rails.root.join('tmp', 'rent_cafe.lock')

    title                         './Identification/MarketingName'
    external_cms_id               './Identification/PrimaryID'
    street_address                './Identification/Address/Address1'
    state                         './Identification/Address/State'
    city                          './Identification/Address/City'
    availability_url              './Availability'

    floor_plan_external_cms_id    './Floorplan', :attribute => 'id'
    floor_plan_name               './Name'
    floor_plan_available_units    './UnitsAvailable'
    floor_plan_availability_url   './Amenities/General'
    floor_plan_bedroom_count      './Room[@type="bedroom"]/Count'
    floor_plan_bathroom_count     './Room[@type="bathroom"]/Count'

    floor_plan_min_square_feet    './SquareFeet', :attribute => 'min'
    floor_plan_max_square_feet    './SquareFeet', :attribute => 'max'
    floor_plan_min_rent           './MarketRent', :attribute => 'min'
    floor_plan_max_rent           './MarketRent', :attribute => 'max'

    office_hour_open_time         './OpenTime'
    office_hour_close_time        './CloseTime'
    office_hour_day               './Day'

    def process_floor_plans(property)
      # Floor plan images are stored outside of the Floorplan node. This
      # overrides the floor plan processing logic to fetch the file node
      # by id
      property.xpath('./Floorplan').each do |plan|
        file  = property.xpath("./File[@id=#{plan['id']}]").first
        attrs = floor_plan_attributes(plan)

        attrs.merge!(
          :external_cms_file_id => (file['id'] rescue nil),
          :image_url            => (file.at('./Src').content rescue nil),
          :rolled_up            => false
        )

        create_or_update_floor_plan(attrs)
      end
    end
  end
end
