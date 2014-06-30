module Bozzuto
  module ExternalFeed
    class Property < Bozzuto::ExternalFeed::FeedObject
      has_attributes_for :feed, [
        :title,
        :street_address,
        :city,
        :county,
        :state,
        :availability_url,
        :office_hours,
        :external_cms_id,
        :external_cms_type,
        :floor_plans
      ]

      has_attributes_for :database, [
        :title,
        :street_address,
        :availability_url,
        :office_hours,
        :external_cms_id,
        :external_cms_type
      ]
    end
  end
end
