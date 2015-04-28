module Bozzuto::Searches
  module Full
    class FloorPlanSearch < Search
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

      def associated_values
        super.where associated_table[:available_units].gt(0)
      end
    end
  end
end
