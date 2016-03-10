module Bozzuto::Searches
  module Partial
    class FloorPlanSearch < Search
      def main_class
        ApartmentCommunity
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

      def join_condition
        super.and associated_table[:available_units].gt(0)
      end
    end
  end
end
