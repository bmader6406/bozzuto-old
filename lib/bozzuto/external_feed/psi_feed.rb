module Bozzuto
  module ExternalFeed
    autoload :OccupancyParsers, Rails.root.join('lib', 'bozzuto', 'external_feed', 'occupancy_parsers.rb')

    class PsiFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :psi


      private

      def build_property(property)
        Bozzuto::ExternalFeed::Property.new(
          :title              => string_at(property, './PropertyID/MarketingName'),
          :street_address     => string_at(property, './PropertyID/Address/Address'),
          :city               => string_at(property, './PropertyID/Address/City'),
          :state              => string_at(property, './PropertyID/Address/State'),
          :availability_url   => string_at(property, './Information/PropertyAvailabilityURL'),
          :external_cms_id    => string_at(property, './PropertyID/Identification/IDValue'),
          :external_cms_type  => feed_type.to_s,
          :unit_count         => int_at(property, './Information/UnitCount'),
          :office_hours       => build_office_hours(property),
          :floor_plans        => build_floor_plans(property),
          :apartment_units    => build_apartment_units(property),
          :property_amenities => build_property_amenities(property)
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
          :external_cms_id   => string_at(plan, './Identification/IDValue'),
          :external_cms_type => feed_type.to_s
        )
      end

      def build_apartment_unit(property, unit)
        address_parts                  = string_at(unit, './Units/Unit/Address/Address').split(', ')
        address_line_1, address_line_2 = address_parts.size > 1 ? address_parts : address_parts << nil
        effective_rent                 = float_at(unit, './EffectiveRent')
        occupancy_parser               = OccupancyParsers.for(feed_type).new(unit)


        Bozzuto::ExternalFeed::ApartmentUnit.new(
          :external_cms_id              => string_at(unit, './Identification/IDValue'),
          :external_cms_type            => feed_type.to_s,
          :building_external_cms_id     => string_at(unit, './Units/Unit', 'BuildingId'),
          :floorplan_external_cms_id    => string_at(unit, './Units/Unit', 'FloorPlanId'),
          :organization_name            => string_at(unit, './Identification/OrganizationName'),
          :marketing_name               => string_at(unit, './Units/Unit/MarketingName'),
          :unit_type                    => string_at(unit, './Units/Unit/UnitType'),
          :bedrooms                     => float_at(unit, './Units/Unit/UnitBedrooms'),
          :bathrooms                    => float_at(unit, './Units/Unit/UnitBathrooms'),
          :min_square_feet              => int_at(unit, './Units/Unit/MinSquareFeet'),
          :max_square_feet              => int_at(unit, './Units/Unit/MaxSquareFeet'),
          :square_foot_type             => string_at(unit, './Units/Unit/SquareFootType'),
          :unit_rent                    => float_at(unit, './Units/Unit/UnitRent'),
          :market_rent                  => float_at(unit, './Units/Unit/MarketRent'),
          :economic_status              => string_at(unit, './Units/Unit/UnitEconomicStatus'),
          :economic_status_description  => string_at(unit, './Units/Unit/UnitEconomicStatusDescription'),
          :occupancy_status             => string_at(unit, './Units/Unit/UnitOccupancyStatus'),
          :occupancy_status_description => string_at(unit, './Units/Unit/UnitOccupancyStatusDescription'),
          :leased_status                => string_at(unit, './Units/Unit/UnitLeasedStatus'),
          :leased_status_description    => string_at(unit, './Units/Unit/UnitLeasedStatusDescription'),
          :number_occupants             => int_at(unit, './Units/Unit/NumberOccupants', 'Total'),
          :floor_plan_name              => string_at(unit, './Units/Unit/FloorplanName'),
          :phase_name                   => string_at(unit, './Units/Unit/PhaseName'),
          :building_name                => string_at(unit, './Units/Unit/BuildingName'),
          :address_line_1               => address_line_1,
          :address_line_2               => address_line_2,
          :city                         => string_at(unit, './Units/Unit/Address/City'),
          :state                        => string_at(unit, './Units/Unit/Address/State'),
          :zip                          => string_at(unit, './Units/Unit/Address/PostalCode'),
          :min_rent                     => effective_rent,
          :max_rent                     => effective_rent,
          :avg_rent                     => effective_rent,
          :vacate_date                  => occupancy_parser.vacate_date,
          :vacancy_class                => occupancy_parser.vacancy_class,
          :availability_url             => string_at(unit, './Availability/UnitAvailabilityURL')
        )
      end


      def build_property_amenities(property)
        property.xpath('./Amenities/PropertyAmenities/Amenity').map do |amenity|
          build_property_amenity(amenity)
        end
      end

      def build_property_amenity(amenity)
        Bozzuto::ExternalFeed::PropertyAmenity.new(
          :primary_type => 'Other',
          :description  => string_at(amenity, './Name')
        )
      end
    end
  end
end
