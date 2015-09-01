module Bozzuto::ExternalFeed
  module OccupancyParsers
    def self.for(feed_type)
      {
        'rent_cafe'     => RentCafe,
        'property_link' => PropertyLink
      }.fetch(feed_type.to_s, StandardParser)
    end
  end
end
