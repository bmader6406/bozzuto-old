module Bozzuto
  module ExternalFeed
    class OfficeHour < Bozzuto::ExternalFeed::FeedObject
      attr_reader :day,
                  :closed,
                  :opens_at,
                  :opens_at_period,
                  :closes_at,
                  :closes_at_period

      self.database_attributes = [
        :day,
        :closed,
        :opens_at,
        :opens_at_period,
        :closes_at,
        :closes_at_period
      ]

      def initialize(attrs = {})
        [attrs.fetch(:opens_at), attrs.fetch(:closes_at)].tap do |(opens_at, closes_at)|
          @day                          = Bozzuto::OfficeHours::DAY_MAPPING.fetch attrs.fetch(:day)
          @closed                       = [opens_at.to_s.downcase, closes_at.to_s.downcase].include?('closed')
          @opens_at, @opens_at_period   = opens_at.match(Bozzuto::OfficeHours::TIME_PARSER).try(:captures) if opens_at
          @closes_at, @closes_at_period = closes_at.match(Bozzuto::OfficeHours::TIME_PARSER).try(:captures) if closes_at
        end
      end
    end
  end
end
