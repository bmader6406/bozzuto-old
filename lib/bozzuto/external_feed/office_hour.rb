module Bozzuto
  module ExternalFeed
    class OfficeHour < Bozzuto::ExternalFeed::FeedObject
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

          @day                          = Bozzuto::OfficeHours::DAY_MAPPING.fetch attrs.fetch(:day)
          @opens_at, @opens_at_period   = opens_at.match(Bozzuto::OfficeHours::TIME_PARSER).captures
          @closes_at, @closes_at_period = closes_at.match(Bozzuto::OfficeHours::TIME_PARSER).captures
        end
      end
    end
  end
end
