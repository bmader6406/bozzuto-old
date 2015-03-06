module Bozzuto
  module ExternalFeed
    class OfficeHour < Bozzuto::ExternalFeed::FeedObject
      DAY_MAPPING = Date::DAYNAMES.each_with_index.reduce(Hash.new) do |mapping, (day_name, i)|
        mapping.merge(day_name => i)
      end.merge('Su' => 0, 'M' => 1, 'T' => 2, 'W' => 3, 'Th' => 4, 'F' => 5, 'Sa' => 6)

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
        [attrs.fetch(:opens_at), attrs.fetch(:closes_at)].tap do |(opens_at, closes_at)|
          return if opens_at == 'Closed' || closes_at == 'Closed'

          @day                          = DAY_MAPPING.fetch attrs.fetch(:day)
          @opens_at, @opens_at_period   = opens_at.match(TIME_PARSER).captures
          @closes_at, @closes_at_period = closes_at.match(TIME_PARSER).captures
        end
      end
    end
  end
end
