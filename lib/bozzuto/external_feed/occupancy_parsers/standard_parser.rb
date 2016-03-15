module Bozzuto
  module ExternalFeed
    module OccupancyParsers
      class StandardParser < Struct.new(:xml)
        include XpathParsing

        OCCUPIED   = 'Occupied'
        UNOCCUPIED = 'Unoccupied'

        def vacancy_class
          @vacancy_class ||= (vacancy_class_content.empty? || occupied?) ? OCCUPIED : UNOCCUPIED
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
    end
  end
end
