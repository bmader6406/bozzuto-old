module Bozzuto
  module ExternalFeed
    class RentCafeFeed < Bozzuto::ExternalFeed::Feed
      self.feed_type = :rent_cafe


      private

      def build_property(property)
        Bozzuto::ExternalFeed::Property.new(
          :title             => string_at(property, './Identification/MarketingName'),
          :street_address    => string_at(property, './Identification/Address/Address1'),
          :city              => string_at(property, './Identification/Address/City'),
          :state             => string_at(property, './Identification/Address/State'),
          :availability_url  => string_at(property, './Availability'),
          :external_cms_id   => string_at(property, './Identification/PrimaryID'),
          :external_cms_type => feed_type.to_s,
          :office_hours      => build_office_hours(property),
          :floor_plans       => build_floor_plans(property)
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
          :floor_plan_group  => floor_plan_group(bedrooms, comment),
          :external_cms_id   => plan['id'],
          :external_cms_type => feed_type.to_s
        )
      end

      def floor_plan_image_url(property, plan)
        file = property.xpath("./File[@id=#{plan['id']}]").first

        if file
          string_at(file, './Src')
        else
          nil
        end
      end
    end
  end
end

