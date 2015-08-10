module Bozzuto
  module ExternalFeed
    class PropertyLinkFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :property_link


      private

      def build_property(property)
        Bozzuto::ExternalFeed::Property.new(
          :title                  => string_at(property, './PropertyID/Identification/MarketingName'),
          :street_address         => string_at(property, './PropertyID/Address/Address1'),
          :city                   => string_at(property, './PropertyID/Address/City'),
          :state                  => string_at(property, './PropertyID/Address/State'),
          :availability_url       => string_at(property, './Information/PropertyAvailabilityURL'),
          :external_cms_id        => string_at(property, './PropertyID/Identification/PrimaryID'),
          :external_cms_type      => feed_type.to_s,
          :external_management_id => property['ManagementID'],
          :unit_count             => int_at(property, './Information/UnitCount'),
          :office_hours           => build_office_hours(property),
          :floor_plans            => build_floor_plans(property),
          :apartment_units        => build_apartment_units(property),
          :property_amenities     => build_property_amenities(property)
        )
      end

      def build_floor_plan(property, plan)
        bedrooms = int_at(plan, './Room[@Type="Bedroom"]/Count')
        comment  = string_at(plan, './Comment')

        Bozzuto::ExternalFeed::FloorPlan.new(
          :name              => string_at(plan, './Name'),
          :availability_url  => string_at(plan, './FloorplanAvailabilityURL'),
          :available_units   => int_at(plan, './DisplayedUnitsAvailable'),
          :bedrooms          => bedrooms,
          :bathrooms         => float_at(plan, './Room[@Type="Bathroom"]/Count'),
          :min_square_feet   => int_at(plan, './SquareFeet', 'Min'),
          :max_square_feet   => int_at(plan, './SquareFeet', 'Max'),
          :min_rent          => float_at(plan, './MarketRent', 'Min'),
          :max_rent          => float_at(plan, './MarketRent', 'Max'),
          :image_url         => floor_plan_image_url(property, plan),
          :unit_count        => int_at(plan, './UnitCount'),
          :floor_plan_group  => floor_plan_group(bedrooms, comment),
          :external_cms_id   => plan['Id'],
          :external_cms_type => feed_type.to_s
        )
      end

      def build_apartment_unit(property, unit)
        Bozzuto::ExternalFeed::ApartmentUnit.new(
          :external_cms_id              => unit['Id'],
          :external_cms_type            => feed_type.to_s,
          :building_external_cms_id     => unit['BuildingID'],
          :floorplan_external_cms_id    => unit['FloorplanID'],
          :bedrooms                     => float_at(unit, './Unit/Information/UnitBedrooms'),
          :bathrooms                    => float_at(unit, './Unit/Information/UnitBathrooms'),
          :min_square_feet              => int_at(unit, './Unit/Information/MinSquareFeet'),
          :max_square_feet              => int_at(unit, './Unit/Information/MaxSquareFeet'),
          :market_rent                  => float_at(unit, './Unit/Information/MarketRent'),
          :occupancy_status             => string_at(unit, './Unit/Information/UnitOccupancyStatus'),
          :leased_status                => string_at(unit, './Unit/Information/UnitLeasedStatus'),
          :primary_property_id          => string_at(unit, './Unit/PropertyPrimaryID'),
          :marketing_name               => string_at(unit, './Unit/MarketingName'),
          :comment                      => string_at(unit, './Comment'),
          :vacancy_class                => string_at(unit, './Availability/VacancyClass'),
          :made_ready_date              => date_for(unit.at('./Availability/MadeReadyDate')),
          :include_in_export            => true
        )
      end
    end
  end
end
