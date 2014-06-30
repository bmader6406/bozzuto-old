module Bozzuto
  module ExternalFeed
    class PropertyLinkFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :property_link


      private

      def build_property(property)
        Bozzuto::ExternalFeed::Property.new(
          :title             => string_at(property, './PropertyID/Identification/MarketingName'),
          :street_address    => string_at(property, './PropertyID/Address/Address1'),
          :city              => string_at(property, './PropertyID/Address/City'),
          :state             => string_at(property, './PropertyID/Address/State'),
          :availability_url  => string_at(property, './Information/PropertyAvailabilityURL'),
          :external_cms_id   => string_at(property, './PropertyID/Identification/PrimaryID'),
          :external_cms_type => feed_type.to_s,
          :office_hours      => build_office_hours(property),
          :floor_plans       => build_floor_plans(property)
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
          :floor_plan_group  => floor_plan_group(bedrooms, comment),
          :external_cms_id   => plan['Id'],
          :external_cms_type => feed_type.to_s
        )
      end
    end
  end
end
