module Bozzuto
  module ExternalFeed
    class Property < Bozzuto::ExternalFeed::FeedObject
      attr_accessor :title,
                    :street_address,
                    :city,
                    :state,
                    :availability_url,
                    :office_hours,
                    :external_cms_id,
                    :external_cms_type,
                    :external_management_id,
                    :unit_count,
                    :floor_plans,
                    :apartment_units,
                    :property_amenities

      self.database_attributes = [
        :title,
        :street_address,
        :availability_url,
        :external_cms_id,
        :external_cms_type,
        :external_management_id,
        :unit_count
      ]
    end
  end
end
