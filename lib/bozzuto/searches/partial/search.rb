module Bozzuto::Searches
  module Partial
    class Search < SearchBase
      # Partial searches return results matching any one criterium.
      #
      # SQL output given the following:
      #   main_class       == ApartmentCommunity
      #   associated_class == ApartmentFloorPlan
      #   foreign_key      == 'apartment_community_id'
      #   search_column    == 'floor_plan_group_id'
      #
      #   apartment_communities.id IN (
      #     SELECT apartment_communities.id
      #     FROM apartment_communities
      #     INNER JOIN apartment_floor_plans
      #     ON apartment_floor_plans.apartment_community_id = apartment_communities.id
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
