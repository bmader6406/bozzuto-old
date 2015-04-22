module Bozzuto
  module ExternalFeed
    class PropertyAmenity < Bozzuto::ExternalFeed::FeedObject
      attr_accessor :primary_type,
                    :sub_type,
                    :description,
                    :position

      self.database_attributes = [
        :primary_type,
        :sub_type,
        :description,
        :position
      ]
    end
  end
end
