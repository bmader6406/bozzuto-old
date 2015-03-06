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
                    :floor_plans

      self.database_attributes = [
        :title,
        :street_address,
        :availability_url,
        :external_cms_id,
        :external_cms_type
      ]
    end
  end
end
