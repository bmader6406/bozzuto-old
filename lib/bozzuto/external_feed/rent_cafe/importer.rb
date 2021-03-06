module Bozzuto
  module ExternalFeed
    module RentCafe
      class Importer < ::Bozzuto::ExternalFeed::Importer

        def feed_type
          "rent_cafe"
        end

        private

        def build_property(property)
          Bozzuto::ExternalFeed::Property.new(
            :title                  => string_at(property, './Identification/MarketingName'),
            :street_address         => string_at(property, './Identification/Address/Address1'),
            :city                   => string_at(property, './Identification/Address/City'),
            :state                  => string_at(property, './Identification/Address/State'),
            :availability_url       => string_at(property, './Availability'),
            :external_cms_id        => string_at(property, './Identification/PrimaryID'),
            :external_cms_type      => feed_type.to_s,
            :external_management_id => property['managementID'],
            :unit_count             => int_at(property, './Information/UnitCount'),
            :office_hours           => build_office_hours(property),
            :floor_plans            => build_floor_plans(property),
            :apartment_units        => build_apartment_units(property),
            :property_amenities     => build_property_amenities(property)
          )
        end

        def build_floor_plan(property, plan)
          bedrooms = int_at(plan, './Room[@type="bedroom"]/Count')
          comment  = string_at(plan, './Comment')

          Bozzuto::ExternalFeed::FloorPlan.new(
            :name              => string_at(plan, './Name'),
            :availability_url  => string_at(plan, './Amenities/General'),
            :available_units   => int_at(plan, './UnitsAvailable'),
            :bedrooms          => bedrooms,
            :bathrooms         => float_at(plan, './Room[@type="bathroom"]/Count'),
            :min_square_feet   => int_at(plan, './SquareFeet', 'min'),
            :max_square_feet   => int_at(plan, './SquareFeet', 'max'),
            :min_rent          => float_at(plan, './MarketRent', 'min'),
            :max_rent          => float_at(plan, './MarketRent', 'max'),
            :image_url         => floor_plan_image_url(property, plan),
            :unit_count        => int_at(plan, './UnitCount'),
            :floor_plan_group  => floor_plan_group(bedrooms, comment),
            :external_cms_id   => plan['id'],
            :external_cms_type => feed_type.to_s
          )
        end

        def build_apartment_unit(property, unit)
          id               = string_at(unit, './UnitID')
          occupancy_parser = OccupancyParsers.for(feed_type).new(unit)

          Bozzuto::ExternalFeed::ApartmentUnit.new(
            :external_cms_id              => id,
            :external_cms_type            => feed_type.to_s,
            :unit_type                    => string_at(unit, './UnitType'),
            :building_external_cms_id     => string_at(unit, './ExtId'), # Is this thing actually the building ID? ..It's the actual ID.  >.<
            :floorplan_external_cms_id    => string_at(unit, './FloorplanID'),
            :floor_plan_name              => string_at(unit, './FloorplanName'),
            :bedrooms                     => float_at(unit, './UnitBedrooms'),
            :bathrooms                    => float_at(unit, './UnitBathrooms'),
            :min_square_feet              => int_at(unit, './MinSquareFeet'),
            :max_square_feet              => int_at(unit, './MaxSquareFeet'),
            :square_foot_type             => string_at(unit, './SquareFootType'),
            :unit_rent                    => float_at(unit, './UnitRent'),
            :market_rent                  => float_at(unit, './MarketRent'),
            :economic_status              => string_at(unit, './UnitEconomicStatus'),
            :economic_status_description  => string_at(unit, './UnitEconomicStatusDescription'),
            :occupancy_status             => string_at(unit, './UnitOccupancyStatus'),
            :leased_status                => string_at(unit, './UnitLeasedStatus'),
            :leased_status_description    => string_at(unit, './UnitLeasedStatusDescription'),
            :primary_property_id          => string_at(unit, './PropertyPrimaryID'),
            :made_ready_date              => date_for(unit.at('./DateAvailable')),
            :availability_url             => string_at(unit, './ApplyOnlineURL'),
            :vacancy_class                => occupancy_parser.vacancy_class,
            :vacate_date                  => occupancy_parser.vacate_date,
            :apartment_unit_amenities     => build_apartment_unit_amenities(unit),
            :files                        => build_files(property, id)
          )
        end

        def floor_plan_image_url(property, plan)
          file = property.xpath("./File[@id=#{plan['id']}]").first

          if file
            url_at(file, './Src')
          else
            nil
          end
        end

        def build_apartment_unit_amenities(unit)
          string_at(unit, './UnitAmenityList').split(',').map do |amenity|
            Bozzuto::ExternalFeed::ApartmentUnitAmenity.new(:primary_type => 'Other', :description => amenity.strip)
          end
        end

        def build_property_amenities(property)
          property.xpath('./Amenities/Community').first.element_children.map do |amenity|
            build_property_amenity(amenity)
          end.compact
        end

        def build_property_amenity(amenity)
          if amenity.text == 'true'
            Bozzuto::ExternalFeed::PropertyAmenity.new(:primary_type => amenity.name)
          end
        end
      end
    end
  end
end
