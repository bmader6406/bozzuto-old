module Bozzuto
  module ExternalFeed
    module PropertyLink
      class Importer < ::Bozzuto::ExternalFeed::Importer

        def feed_type
          "property_link"
        end

        private

        def build_property(property)
          Bozzuto::ExternalFeed::Property.new(
            :title                  => string_at(property, './PropertyID/MarketingName'),
            :street_address         => string_at(property, './PropertyID/Address/Address'),
            :city                   => string_at(property, './PropertyID/Address/City'),
            :state                  => string_at(property, './PropertyID/Address/State'),
            :availability_url       => string_at(property, './Information/PropertyAvailabilityURL'),
            :external_cms_id        => string_at(property, './PropertyID/Identification/IDValue'),
            :external_cms_type      => feed_type.to_s,
            :external_management_id => string_at(property, './Identification[@IDType="ManagementID"]/IDValue'),
            :unit_count             => int_at(property, './Information/UnitCount'),
            :office_hours           => build_office_hours(property),
            :floor_plans            => build_floor_plans(property),
            :apartment_units        => build_apartment_units(property),
            :property_amenities     => build_property_amenities(property)
          )
        end

        def build_floor_plan(property, plan)
          bedrooms = int_at(plan, './Room[@RoomType="Bedroom"]/Count')
          comment  = string_at(plan, './Comment')

          Bozzuto::ExternalFeed::FloorPlan.new(
            :name              => string_at(plan, './Name'),
            :availability_url  => string_at(plan, './FloorplanAvailabilityURL'),
            :available_units   => int_at(plan, './DisplayedUnitsAvailable'),
            :bedrooms          => bedrooms,
            :bathrooms         => float_at(plan, './Room[@RoomType="Bathroom"]/Count'),
            :min_square_feet   => int_at(plan, './SquareFeet', 'Min'),
            :max_square_feet   => int_at(plan, './SquareFeet', 'Max'),
            :min_rent          => float_at(plan, './MarketRent', 'Min'),
            :max_rent          => float_at(plan, './MarketRent', 'Max'),
            :image_url         => floor_plan_image_url(property, plan),
            :unit_count        => int_at(plan, './UnitCount'),
            :floor_plan_group  => floor_plan_group(bedrooms, comment),
            :external_cms_id   => string_at(plan, './Identification[@IDType="FloorplanID"]/IDValue'),
            :external_cms_type => feed_type.to_s
          )
        end

        def build_apartment_unit(property, unit)
          occupancy_parser = OccupancyParsers.for(feed_type).new(unit)

          Bozzuto::ExternalFeed::ApartmentUnit.new(
            :external_cms_id              => string_at(unit, '.Units/Unit/Identification[@IDType="FloorplanID"]/IDValue'),
            :external_cms_type            => feed_type.to_s,
            :building_external_cms_id     => string_at(unit, './Units/Unit/BuildingName'),
            :floorplan_external_cms_id    => string_at(unit, './Identification[@IDType="FloorplanID"]/IDValue'),
            :bedrooms                     => float_at(unit, './Units/Unit/UnitBedrooms'),
            :bathrooms                    => float_at(unit, './Units/Unit/UnitBathrooms'),
            :min_square_feet              => int_at(unit, './Units/Unit/MinSquareFeet'),
            :max_square_feet              => int_at(unit, './Units/Unit/MaxSquareFeet'),
            :market_rent                  => float_at(unit, './Units/Unit/UnitRent'),
            :occupancy_status             => string_at(unit, './Units/Unit/UnitOccupancyStatus'),
            :leased_status                => string_at(unit, './Units/Unit/UnitLeasedStatus'),
            :primary_property_id          => string_at(unit, './Unit/PropertyPrimaryID'),
            :marketing_name               => string_at(unit, './Units/Unit/MarketingName'),
            :comment                      => string_at(unit, './Comment'),
            :vacancy_class                => occupancy_parser.vacancy_class,
            :vacate_date                  => occupancy_parser.vacate_date,
            :made_ready_date              => date_for(unit.at('./Availability/MadeReadyDate'))
          )
        end

        def build_property_amenity(amenity)
          Bozzuto::ExternalFeed::PropertyAmenity.new(
            :primary_type => amenity['AmenityType'],
            :sub_type     => amenity['SubType'],
            :description  => string_at(amenity, './Description'),
            :position     => int_at(amenity, './Rank')
          )
        end
      end
    end
  end
end
