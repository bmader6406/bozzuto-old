
module Bozzuto
  module OfficeHours
    DAY_MAPPING = {
      'Sunday'    => 0,
      'Monday'    => 1,
      'Tuesday'   => 2,
      'Wednesday' => 3,
      'Thursday'  => 4,
      'Friday'    => 5,
      'Saturday'  => 6,
      'Su'        => 0,
      'M'         => 1,
      'T'         => 2,
      'W'         => 3,
      'Th'        => 4,
      'F'         => 5,
      'Sa'        => 6,
      'Sun'       => 0,
      'Mon'       => 1,
      'Tue'       => 2,
      'Wed'       => 3,
      'Thu'       => 4,
      'Fri'       => 5,
      'Sat'       => 6
    }

    PARSER = %r{
      (
        (?<start_of_range>M\w*|T\w*|W\*|F\w*|S\w*) # Optional start of day range
        \s*-\s*                                    # Followed by a dash
      )*

      (?<day>M\w*|T\w*|W\*|F\w*|S\w*)              # Day (possible end-of-range)
      :*\s*

      (
        (?<start_time>[01]{0,1}\d(:\d\d)*)         # Start Time (HH:MM)
        \s*
        (?<start_period>am|AM|pm|PM){0,1}          # Start Period (am, pm, AM, or PM)
      )

      (\s*-\s*)*                                   # Followed by a dash

      (
        (?<end_time>[01]{0,1}\d(:\d\d)*)           # End Time (HH:MM)
        \s*
        (?<end_period>am|AM|pm|PM){0,1}            # End Period (am, pm, AM, or PM)
      )
    }x

    # Matches office hours in formats like:
    #   Monday - Thursday 9:00am-6:00pm
    #   Friday 8:00-5:00
    #   Saturday 10:00am-5:00pm

    TIME_PARSER = /(?<time>[12]{0,1}\d:\d\d)[:\d\d]*\s*(?<period>am|AM|pm|PM)/

    # Covers the formats that show up in the feeds:
    #   12:00 PM
    #   08:00:00 AM

    def self.create_records_for(property)
      if property.contact_page.present?
        load_from_page_content(property)
      else
        load_from_serialized_office_hours(property)
      end
    end

    private

    def self.load_from_page_content(property)
      text_content = Nokogiri::HTML(property.contact_page.content).search('//text()').text
      text_content.scan(PARSER).map do |office_hour_data|
        OfficeHour.new(*office_hour_data).create_records_for(property)
      end
    end

    def self.load_from_serialized_office_hours(property)
      property.read_attribute(:office_hours).to_a.map do |office_hour|
        day                         = DAY_MAPPING.fetch office_hour.fetch(:day)
        opens_at, opens_at_period   = office_hour.fetch(:open_time).match(TIME_PARSER).captures
        closes_at, closes_at_period = office_hour.fetch(:close_time).match(TIME_PARSER).captures

        property.office_hours.create(
          :day              => day,
          :opens_at         => opens_at,
          :opens_at_period  => opens_at_period,
          :closes_at        => closes_at,
          :closes_at_period => closes_at_period
        )
      end
    end

    class OfficeHour < Struct.new(:range_start_day, :day, :opens_at, :opens_at_period, :closes_at, :closes_at_period)
      def create_records_for(property)
        return unless valid_days?

        if range?
          days.map { |day| property.office_hours.create(attributes(day)) }
        else
          property.office_hours.create(attributes)
        end
      end

      def attributes(day_number = last_day)
        {
          :day              => day_number,
          :opens_at         => opens_at,
          :opens_at_period  => opens_at_period.try(:upcase),
          :closes_at        => closes_at,
          :closes_at_period => closes_at_period.try(:upcase)
        }.keep_if { |attr, value| value.present? }
      end

      private

      def valid_days?
        if range?
          first_day.present? && last_day.present?
        else
          last_day.present?
        end
      end

      def range?
        range_start_day.present?
      end

      def days
        if first_day < last_day
          [*first_day..last_day]
        else
          [first_day..6] | [0..last_day]
        end
      end

      def first_day
        DAY_MAPPING[range_start_day]
      end

      def last_day
        DAY_MAPPING[day]
      end
    end
  end
end
