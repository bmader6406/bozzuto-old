module Bozzuto::ExternalFeed
  module OccupancyParsers
    class RentCafe < StandardParser
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

      def vacate_date
        @vacate_date ||= Chronic.parse(string_at(xml, vacate_date_xpath)).try(:to_date)
      end

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
  end
end
