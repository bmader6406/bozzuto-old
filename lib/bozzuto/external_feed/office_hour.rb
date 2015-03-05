module Bozzuto
  module ExternalFeed
    class OfficeHour < Bozzuto::ExternalFeed::FeedObject
      DAY_MAPPING = {
        'Sunday'    => 0,
        'Su'        => 0,
        'Monday'    => 1,
        'M'         => 1,
        'Tuesday'   => 2,
        'T'         => 2,
        'Wednesday' => 3,
        'W'         => 3,
        'Thursday'  => 4,
        'Th'        => 4,
        'Friday'    => 5,
        'F'         => 5,
        'Saturday'  => 6,
        'Sa'        => 6
      }

      # Covers the formats that show up in the feeds:
      #   12:00 PM
      #   08:00:00 AM

      TIME_PARSER = /(?<time>[12]{0,1}\d:\d\d)[:\d\d]*\s*(?<period>AM|PM)/

      attr_reader :day,
                  :opens_at,
                  :opens_at_period,
                  :closes_at,
                  :closes_at_period

      self.database_attributes = [
        :day,
        :opens_at,
        :opens_at_period,
        :closes_at,
        :closes_at_period
      ]

      def initialize(attrs = {})
        @day                          = DAY_MAPPING.fetch attrs.fetch(:day)
        @opens_at, @opens_at_period   = attrs.fetch(:opens_at).match(TIME_PARSER).captures
        @closes_at, @closes_at_period = attrs.fetch(:closes_at).match(TIME_PARSER).captures
      end
    end
  end
end
