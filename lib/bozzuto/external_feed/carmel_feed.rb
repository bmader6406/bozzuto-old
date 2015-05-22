module Bozzuto
  module ExternalFeed
    class CarmelFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :carmel

      private

      def build_property(property)
        Bozzuto::ExternalFeed::Property.new(
          :title              => string_at(property, './PropertyID/Identification/MarketingName'),
          :city               => 'Falls Church', # Workaround -- feed will not provide address info
          :state              => 'VA',           # Using a default city since it's a required field
          :external_cms_id    => string_at(property, './PropertyID/Identification/PrimaryID'),
          :external_cms_type  => feed_type.to_s,
          :floor_plans        => build_floor_plans(property),
          :office_hours       => [], # Carmel does not contain any office hour data
          :apartment_units    => [], # Carmel does not contain any unit-level data
          :property_amenities => []  # Carmel does not contain any amenity data
        )
      end

      def build_floor_plan(property, plan)
        bedrooms  = int_at(plan, './Bedrooms')
        bathrooms = number_of_bathrooms(plan)
        comment   = string_at(plan, './Comment')

        Bozzuto::ExternalFeed::FloorPlan.new(
          :name              => string_at(plan, './Name'),
          :availability_url  => string_at(plan, './FloorplanAvailabilityURL'),
          :available_units   => int_at(plan, './DisplayedUnitsAvailable'),
          :bedrooms          => bedrooms,
          :bathrooms         => bathrooms,
          :min_square_feet   => int_at(plan, './SquareFeet', 'Min'),
          :max_square_feet   => int_at(plan, './SquareFeet', 'Max'),
          :min_rent          => float_at(plan, './MarketRent', 'Min'),
          :max_rent          => float_at(plan, './MarketRent', 'Max'),
          :floor_plan_group  => floor_plan_group(bedrooms, comment),
          :external_cms_id   => plan['id'],
          :external_cms_type => feed_type.to_s
        )
      end

      def number_of_bathrooms(plan)
        value      = value_at(plan, './Bathrooms')
        half_baths = value.to_s.include?('H') ? 0.5 : 0

        value.to_f + half_baths
      end
    end
  end
end
