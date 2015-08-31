module Bozzuto::Exports
  module Formats
    class Mits4_1 < Format
      private

      def property_node(parent_node, property)
        parent_node.tag!('Property', 'IDValue' => property.id) do |node|
          property_id_node(node, property)
          identification_node(node, property)
          information_node(node, property)

          property.floor_plans.each do |floor_plan|
            floorplan_node(node, floor_plan)
          end

          property.floor_plans.flat_map(&:units).each do |unit|
            unit_node(node, unit)
          end

          property.slides.each_with_index do |slide, i|
            photo_node(node, property, slide.image_url, :rank => i + 1)
          end

          promotion_nodes(node, property)

          property.property_amenities.each do |amenity|
            property_amenity_node(node, amenity)
          end

          photo_node(node, property, property.listing_image, :rank => property.slides.count + 1)
          video_node(node, property, property.video_url, :rank => property.slides.count + 2)
        end
      end

      def property_id_node(parent_node, property)
        parent_node.tag!('PropertyID') do |node|
          node.tag! 'SyncMgmtID',     property.external_management_id
          node.tag! 'SyncPropertyID', property.external_cms_id
          node.tag! 'MarketingName',  property.title
          node.tag! 'WebSite',        property.website_url
          node.tag! 'Email',          property.lead_2_lease_email

          phone_node(node, property)
          address_node(node, property)
        end
      end

      def phone_node(parent_node, property)
        parent_node.tag!('Phone', 'PhoneType' => 'office') do |node|
          node.tag! 'PhoneNumber', property.phone_number
        end
      end

      def identification_node(parent_node, property)
        parent_node.tag!('ILS_Identification', 'ILS_IdentificationType' => 'Apartment', 'RentalType' => 'Market Rate') do |node|
          node.tag! 'Latitude',  property.latitude
          node.tag! 'Longitude', property.longitude
        end
      end

      def information_node(parent_node, property)
        parent_node.tag!('Information') do |node|
          if property.office_hours.any?
            property.office_hours.each do |office_hour|
              office_hour_node(node, office_hour)
            end
          end

          node.tag! 'UnitCount',               property.unit_count
          node.tag! 'ShortDescription',        strip_tags_and_whitespace(property.meta_description)
          node.tag! 'LongDescription',         strip_tags_and_whitespace(property.overview_text)
          node.tag! 'DrivingDirections',       property.directions_url
          node.tag! 'PropertyAvailabilityURL', property.availability_url
          node.tag! 'FacebookURL',             property.facebook_url
          node.tag! 'TwitterHandle',           property.twitter_handle
          node.tag! 'PinterestURL',            property.pinterest_url
        end
      end

      def office_hour_node(parent_node, office_hour)
        parent_node.tag!('OfficeHour') do |node|
          node.tag! 'OpenTime',  office_hour.opens_at_with_period
          node.tag! 'CloseTime', office_hour.closes_at_with_period
          node.tag! 'Day',       office_hour.day_name
        end
      end

      def promotion_nodes(node, property)
        node.tag! 'Promotion', property.overview_bullet_1 if property.overview_bullet_1?
        node.tag! 'Promotion', property.overview_bullet_2 if property.overview_bullet_2?
        node.tag! 'Promotion', property.overview_bullet_3 if property.overview_bullet_3?
      end

      def property_amenity_node(parent_node, amenity)
        types = {
          'AmenityType'    => amenity.primary_type,
          'AmenitySubType' => amenity.sub_type
        }.keep_if { |type, value| value.present? }

        parent_node.tag!('Amenity', types) do |node|
          node.tag! 'Description', amenity.description
          node.tag! 'Rank',        amenity.position
        end
      end

      # Floorplan-related Nodes

      def floorplan_node(parent_node, floorplan)
        parent_node.tag!('Floorplan', 'IDValue' => floorplan.id) do |node|
          node.tag! 'SyncFloorplanID',          floorplan.external_cms_id
          node.tag! 'Name',                     floorplan.name
          node.tag! 'UnitCount',                floorplan.unit_count
          node.tag! 'FloorplanAvailabilityURL', floorplan.availability_url
          node.tag! 'DisplayedUnitsAvailable',  floorplan.available_units

          bedroom_node(node, floorplan)
          bathroom_node(node, floorplan)

          node.tag! 'SquareFeet',
            'Min' => floorplan.min_square_feet,
            'Max' => floorplan.max_square_feet
          node.tag! 'MarketRent',
            'Min' => format_float_for_xml(floorplan.min_rent),
            'Max' => format_float_for_xml(floorplan.max_rent)
          node.tag! 'EffectiveRent',
            'Min' => format_float_for_xml(floorplan.min_rent),
            'Max' => format_float_for_xml(floorplan.max_rent)

          photo_node(node, floorplan, floorplan.image_url, :file_type => 'Floorplan') if floorplan.image_url
        end
      end

      def bedroom_node(parent_node, floorplan)
        parent_node.tag!('Room', 'RoomType' => 'Bedroom') do |node|
          node.tag! 'Count', floorplan.bedrooms
          node.tag! 'Comment', ''
        end
      end

      def bathroom_node(parent_node, floorplan)
        parent_node.tag!('Room', 'RoomType' => 'Bathroom') do |node|
          node.tag! 'Count', floorplan.bathrooms
          node.tag! 'Comment', ''
        end
      end

      # Unit-related Nodes

      def unit_node(parent_node, unit)
        parent_node.tag!('ILS_Unit', 'IDValue' => unit.id) do |node|
          unit_info_node(node, unit)
          effective_rent_node(node, unit)
          availability_node(node, unit)

          node.tag! 'Comment', unit.comment

          unit.amenities.each do |amenity|
            amenity_node(node, amenity)
          end

          unit.feed_files.each do |file|
            file_node(node, file, unit.floor_plan_id)
          end
        end
      end

      def unit_info_node(parent_node, unit)
        parent_node.tag!('Units') do |node|
          node.tag! 'UnitID',                        unit.id
          node.tag! 'SyncUnitID',                    unit.sync_id
          node.tag! 'MarketingName',                 unit.name
          node.tag! 'UnitType',                      unit.unit_type
          node.tag! 'UnitBedrooms',                  unit.bedrooms
          node.tag! 'UnitBathrooms',                 unit.bathrooms
          node.tag! 'MinSquareFeet',                 unit.min_square_feet
          node.tag! 'MaxSquareFeet',                 unit.max_square_feet
          node.tag! 'SquareFootType',                unit.square_foot_type
          node.tag! 'UnitRent',                      unit.unit_rent
          node.tag! 'MarketRent',                    unit.market_rent
          node.tag! 'UnitEconomicStatus',            unit.economic_status
          node.tag! 'UnitEconomicStatusDescription', unit.economic_status_description
          node.tag! 'NumberOccupants',               unit.number_occupants
          node.tag! 'FloorplanID',                   unit.floor_plan_id
          node.tag! 'FloorplanName',                 unit.floor_plan_name
          node.tag! 'PhaseName',                     unit.phase_name
          node.tag! 'BuildingName',                  unit.building_name

          address_node(parent_node, unit)
        end
      end

      def effective_rent_node(parent_node, unit)
        rent_values = {
          'Avg' => unit.avg_rent,
          'Min' => unit.min_rent,
          'Max' => unit.max_rent
        }.keep_if { |type, value| value.present? }

        return if rent_values['Min'].nil? || rent_values['Max'].nil?

        parent_node.tag!('EffectiveRent', rent_values)
      end

      def availability_node(parent_node, unit)
        parent_node.tag!('Availability') do |node|
          node.tag!('VacateDate',
            'Month' => unit.vacate_date.month,
            'Day'   => unit.vacate_date.day,
            'Year'  => unit.vacate_date.year
          ) if unit.vacate_date?

          node.tag! 'VacancyClass', unit.vacancy_class

          node.tag!('MadeReadyDate',
            'Month' => unit.made_ready_date.month,
            'Day'   => unit.made_ready_date.day,
            'Year'  => unit.made_ready_date.year
          ) if unit.made_ready_date?

          node.tag! 'UnitAvailabilityURL', unit.availability_url
        end
      end

      # Shared Nodes

      def address_node(parent_node, record)
        parent_node.tag!('Address', 'AddressType' => 'property') do |node|
          node.tag! 'AddressLine1', record.address_line_1
          node.tag! 'AddressLine2', (record.address_line_2.presence if record.respond_to?(:address_line_2))
          node.tag! 'City',         record.city
          node.tag! 'State',        record.state
          node.tag! 'PostalCode',   record.zip.presence
          node.tag! 'CountyName',   (record.county.presence if record.respond_to?(:county))
        end
      end

      def amenity_node(parent_node, amenity)
        types = {
          'AmenityType'    => amenity.primary_type,
          'AmenitySubType' => amenity.sub_type
        }.keep_if { |type, value| value.present? }

        parent_node.tag!('Amenity', types) do |node|
          node.tag! 'Description', amenity.description
          node.tag! 'Rank',        amenity.rank
        end
      end

      # In a number of occasions, we only have a URL to go off of..
      def photo_node(parent_node, parent_record, photo_url, options = {})
        return if photo_url.nil?

        parent_node.tag!('File', 'FileID' => parent_record.id, 'Active' => true) do |node|
          node.tag! 'FileType', (options[:file_type] || 'Photo')
          node.tag! 'Name',     File.basename(photo_url)
          node.tag! 'Format',   'image/jpeg'
          node.tag! 'Src',      photo_url
          node.tag! 'Rank',     (options[:rank] || 1).to_s
        end
      end

      def video_node(parent_node, parent_record, video_url, options = {})
        return if video_url.nil?

        parent_node.tag!('File', 'FileID' => parent_record.id, 'Active' => true) do |node|
          node.tag! 'FileType', 'Video'
          node.tag! 'Name',     File.basename(video_url)
          node.tag! 'Src',      video_url
          node.tag! 'Rank',     (options[:rank] || 1).to_s
        end
      end

      def file_node(parent_node, file, id = nil)
        parent_node.tag!('File', 'FileID' => id || file.feed_record_id, 'Active' => file.active) do |node|
          node.tag! 'Description', file.description
          node.tag! 'FileType',    file.file_type
          node.tag! 'Name',        file.name
          node.tag! 'Caption',     file.caption
          node.tag! 'Format',      file.format
          node.tag! 'Src',         file.source
          node.tag! 'Rank',        file.rank
          node.tag! 'AdID',        file.ad_id
          node.tag! 'AffiliateID', file.affiliate_id
        end
      end
    end
  end
end
