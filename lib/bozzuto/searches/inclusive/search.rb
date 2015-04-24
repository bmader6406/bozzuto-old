module Bozzuto::Searches
  module Inclusive
    class Search < Bozzuto::Searches::Search
      # SQL output given the following:
      #   main_class       == Property
      #   associated_class == ApartmentFloorPlan
      #   foreign_key      == 'apartment_community_id'
      #   search_column    == 'floor_plan_group_id'
      #
      #   properties.id IN (
      #     SELECT properties.id
      #     FROM properties
      #     INNER JOIN apartment_floor_plans
      #     ON apartment_floor_plans.apartment_community_id = properties.id
      #     WHERE apartment_floor_plans.floor_plan_group_id IN (?)
      #   )

      private

      def join_clause
        associated_table
      end

      def where_condition
        associated_table[search_column].in Arel.sql(values)
      end
    end
  end
end
