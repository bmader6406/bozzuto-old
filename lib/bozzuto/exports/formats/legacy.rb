module Bozzuto::Exports
  module Formats
    class Legacy < Format
      PATH = APP_CONFIG[:apartment_export_file]

      def self.to_s
        'Legacy'
      end

      private

      def communities
        @communities ||= Bozzuto::Exports::Data.combined_communities
      end

      def property_node(parent_node, property)
        parent_node.tag!('Property') do |node|
          property_id_node(node, property)
          information_node(node, property)

          property.features.each do |feature|
            feature_node(node, feature)
          end

          property.property_features.each do |featured_button|
            featured_button_node(node, featured_button)
          end

          slideshow_node(node, property.slides)

          property.nearby_communities.each do |nearby_community|
            nearby_community_node(node, nearby_community)
          end

          property.floor_plans.each do |floor_plan|
            floorplan_node(node, floor_plan)
          end

          promotion_node(node, property.promo) if property.promo.present?
        end
      end

      def property_id_node(parent_node, property)
        parent_node.tag!('PropertyID') do |node|
          identification_node(node, property)
          address_node(node, property)
          phone_node(node, property)
        end
      end

      def identification_node(parent_node, property)
        parent_node.tag!('Identification') do |node|
          node.tag! 'PrimaryID',     property.id
          node.tag! 'MarketingName', property.title
          node.tag! 'WebSite',       property.website_url
          node.tag! 'BozzutoURL',    property.bozzuto_url
          node.tag! 'Latitude',      property.latitude
          node.tag! 'Longitude',     property.longitude
        end
      end

      def address_node(parent_node, property)
        parent_node.tag!('Address') do |node|
          node.tag! 'Address1',        property.street_address
          node.tag! 'City',            property.city
          node.tag! 'State',           property.state
          node.tag! 'PostalCode',      property.zip_code
          node.tag! 'CountyName',      property.county
          node.tag! 'Lead2LeaseEmail', property.lead_2_lease_email
        end
      end

      def phone_node(parent_node, property)
        parent_node.tag!('Phone', 'Type' => 'office') do |node|
          node.tag! 'PhoneNumber', property.phone_number
        end
      end

      def information_node(parent_node, property)
        parent_node.tag!('Information') do |node|
          if property.office_hours.any?
            property.office_hours.each do |office_hour|
              office_hour_node(node, office_hour)
            end
          end

          node.tag! 'OverviewText',         property.overview_text
          node.tag! 'OverviewTextStripped', strip_tags_and_whitespace(property.overview_text)
          node.tag! 'OverviewBullet1',      property.overview_bullet_1
          node.tag! 'OverviewBullet2',      property.overview_bullet_2
          node.tag! 'OverviewBullet3',      property.overview_bullet_3
          node.tag! 'NeighborhoodText',     property.neighborhood_text
          node.tag! 'DirectionsURL',        property.directions_url
          node.tag! 'ListingImageURL',      property.listing_image
          node.tag! 'VideoURL',             property.video_url
          node.tag! 'FacebookURL',          property.facebook_url
          node.tag! 'TwitterHandle',        property.twitter_handle
          node.tag! 'PinterestURL',         property.pinterest_url
        end
      end

      def office_hour_node(parent_node, office_hour)
        parent_node.tag!('OfficeHour') do |node|
          node.tag! 'OpenTime',  office_hour.opens_at_with_period
          node.tag! 'CloseTime', office_hour.closes_at_with_period
          node.tag! 'Day',       office_hour.day_name
        end
      end

      def feature_node(parent_node, feature)
        parent_node.tag!('Feature') do |node|
          node.tag! 'Title',       feature.title
          node.tag! 'Description', feature.text
        end
      end

      def featured_button_node(parent_node, featured_button)
        parent_node.tag!('FeaturedButton') do |node|
          node.tag! 'Name', featured_button.name
        end
      end

      def slideshow_node(parent_node, slideshow_slides)
        parent_node.tag!('Slideshow') do |node|
          slideshow_slides.each do |slide|
            node.tag! 'SlideshowImageURL', slide.image_url
          end
        end
      end

      def nearby_community_node(parent_node, nearby_community)
        parent_node.tag!('NearbyCommunity', 'Id' => nearby_community.id) do |node|
          node.tag! 'Name', nearby_community.title
        end
      end

      def floorplan_node(parent_node, floorplan)
        parent_node.tag!('Floorplan', 'Id' => floorplan.id) do |node|
          node.tag! 'Name',                     floorplan.name
          node.tag! 'FloorplanAvailabilityURL', floorplan.availability_url
          node.tag! 'DisplayedUnitsAvailable',  floorplan.available_units
          node.tag! 'ImageURL',                 floorplan.image_url if floorplan.image_url
          node.tag! 'Bedrooms',                 floorplan.bedrooms
          node.tag! 'Bathrooms',                floorplan.bathrooms
          node.tag! 'SquareFeet',
            'Min' => floorplan.min_square_feet,
            'Max' => floorplan.max_square_feet
          node.tag! 'MarketRent',
            'Min' => format_float_for_xml(floorplan.min_rent),
            'Max' => format_float_for_xml(floorplan.max_rent)
          node.tag! 'EffectiveRent',
            'Min' => format_float_for_xml(floorplan.min_rent),
            'Max' => format_float_for_xml(floorplan.max_rent)
        end
      end

      def promotion_node(parent_node, promo)
        parent_node.tag!('Promotion') do |node|
          node.tag! 'Title',    promo.title
          node.tag! 'Subtitle', promo.subtitle
          node.tag! 'LinkURL',  promo.link_url
          node.tag! 'ExpirationDate',
            'Month' => promo.expiration_date.try(:strftime, '%m'),
            'Day'   => promo.expiration_date.try(:strftime, '%d'),
            'Year'  => promo.expiration_date.try(:strftime, '%Y')
        end
      end
    end
  end
end
