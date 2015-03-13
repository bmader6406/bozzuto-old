module Bozzuto
  module ExternalFeed
    class ApartmentUnitAmenity < Bozzuto::ExternalFeed::FeedObject
      attr_accessor :primary_type,
                    :sub_type,
                    :description,
                    :rank

      self.database_attributes = [
        :primary_type,
        :sub_type,
        :description,
        :rank
      ]
    end
  end
end
