module Bozzuto::Searches
  module Inclusive
    class FloorPlanSearch < Search
      QUERY = %Q(
        properties.id IN (
          SELECT properties.id
          FROM properties
          INNER JOIN apartment_floor_plans
          ON properties.id = apartment_floor_plans.apartment_community_id
          WHERE apartment_floor_plans.floor_plan_group_id IN (?)
        )
      )

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
