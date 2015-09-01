module Bozzuto
  module ExternalFeed
    autoload :OccupancyParsers, Rails.root.join('lib', 'bozzuto', 'external_feed', 'occupancy_parsers.rb')

    class VaultwareFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :vaultware

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
        occupancy_parser = OccupancyParsers.for(feed_type).new(unit)

        Bozzuto::ExternalFeed::ApartmentUnit.new(
          :external_cms_id              => unit['Id'],
          :external_cms_type            => feed_type.to_s,
          :building_external_cms_id     => unit['BuildingID'],
          :floorplan_external_cms_id    => unit['FloorplanID'],
          :unit_type                    => string_at(unit, './Unit/Information/UnitType'),
          :min_square_feet              => int_at(unit, './Unit/Information/MinSquareFeet'),
          :max_square_feet              => int_at(unit, './Unit/Information/MaxSquareFeet'),
          :leased_status                => string_at(unit, './Unit/Information/UnitLeasedStatus'),
          :primary_property_id          => string_at(unit, './Unit/PropertyPrimaryID'),
          :marketing_name               => string_at(unit, './Unit/MarketingName'),
          :comment                      => string_at(unit, './Comment'),
          :min_rent                     => float_at(unit, './EffectiveRent', 'Min'),
          :max_rent                     => float_at(unit, './EffectiveRent', 'Max'),
          :avg_rent                     => float_at(unit, './EffectiveRent', 'Avg'),
          :vacate_date                  => occupancy_parser.vacate_date,
          :vacancy_class                => occupancy_parser.vacancy_class,
          :availability_url             => CGI.unescapeHTML(string_at(unit, './Availability/UnitAvailabilityURL')),
          :apartment_unit_amenities     => build_apartment_unit_amenities(unit)
        )
      end

      def build_apartment_unit_amenity(amenity)
        Bozzuto::ExternalFeed::ApartmentUnitAmenity.new(
          :primary_type => amenity['Type'],
          :description  => string_at(amenity, './Description'),
          :rank         => int_at(amenity, './Rank')
        )
      end
    end
  end
end
