module Bozzuto
  module Searches
    class FloorPlanSearch < ExclusiveValueSearch
      def main_class
        Property
      end

      def associated_class
        ApartmentFloorPlan
      end

      def foreign_key
        'apartment_community_id'
      end

      def search_column
        'floor_plan_group_id'
      end
    end
  end
end
