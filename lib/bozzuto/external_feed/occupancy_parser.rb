module Bozzuto
  module ExternalFeed
    class OccupancyParser < Struct.new(:xml)
      include XpathParsing

      OCCUPIED   = 'Occupied'
      UNOCCUPIED = 'Unoccupied'

      def self.for(feed_type)
        {
          'rent_cafe'     => RentCafeOccupancyParser,
          'property_link' => PropertyLinkOccupancyParser
        }.fetch(feed_type.to_s, self)
      end

      def vacancy_class
        @vacancy_class ||= occupied? ? OCCUPIED : UNOCCUPIED
      end

      def vacate_date
        @vacate_date ||= date_for(xml.at(vacate_date_xpath))
      end

      private

      def vacancy_class_content
        @vacancy_class_content ||= string_at(xml, vacancy_class_xpath)
      end

      def vacancy_class_xpath
        './Availability/VacancyClass'
      end

      def vacate_date_xpath
        './Availability/VacateDate'
      end

      def occupied?
        vacancy_class_content == OCCUPIED && vacate_date.nil?
      end
    end

    class RentCafeOccupancyParser < OccupancyParser
      OCCUPIED_STATUSES = [
        'Down',
        'Excluded',
        'Model',
        'Notice Rented',
        'Occupied No Notice',
        'Vacant Rented Not Ready',
        'Vacant Rented Ready',
        'Waitlist',
        'Admin',
        'Do Not Show'
      ]

      private

      def vacancy_class_xpath
        './UnitLeasedStatusDescription'
      end

      def vacate_date_xpath
        './DateAvailable'
      end

      def occupied?
        OCCUPIED_STATUSES.include?(vacancy_class_content) || (vacancy_class_content == 'Notice Unrented' && vacate_date.nil?)
      end
    end

    class PropertyLinkOccupancyParser < OccupancyParser
      UNOCCUPIED_STATUSES = [
        'on notice',
        'available'
      ]

      private

      def vacancy_class_xpath
        './Unit/Information/UnitLeasedStatus'
      end

      def vacate_date_xpath
        './Availability/MadeReadyDate'
      end

      def occupied?
        UNOCCUPIED_STATUSES.exclude?(vacancy_class_content)
      end
    end
  end
end
