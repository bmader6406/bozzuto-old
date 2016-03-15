module Bozzuto
  module ExternalFeed
    module OccupancyParsers
      class PropertyLink < StandardParser

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
end
