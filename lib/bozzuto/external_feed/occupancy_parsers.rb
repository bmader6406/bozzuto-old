module Bozzuto
  module ExternalFeed
    module OccupancyParsers

      def self.for(feed_type)
        {
          'rent_cafe'     => ::Bozzuto::ExternalFeed::OccupancyParsers::RentCafe,
          'property_link' => ::Bozzuto::ExternalFeed::OccupancyParsers::PropertyLink
        }.fetch(
          feed_type.to_s,
          ::Bozzuto::ExternalFeed::OccupancyParsers::StandardParser
        )
      end
    end
  end
end
