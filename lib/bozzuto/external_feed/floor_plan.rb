module Bozzuto
  module ExternalFeed
    class FloorPlan < Bozzuto::ExternalFeed::FeedObject
      attr_accessor :name,
                    :external_cms_id,
                    :external_cms_type,
                    :floor_plan_group,
                    :availability_url,
                    :available_units,
                    :bedrooms,
                    :bathrooms,
                    :min_square_feet,
                    :max_square_feet,
                    :min_rent,
                    :max_rent,
                    :image_url

      self.database_attributes = [
        :name,
        :external_cms_id,
        :external_cms_type,
        :availability_url,
        :available_units,
        :bedrooms,
        :bathrooms,
        :min_square_feet,
        :max_square_feet,
        :min_rent,
        :max_rent,
        :image_url
      ]
    end
  end
end
