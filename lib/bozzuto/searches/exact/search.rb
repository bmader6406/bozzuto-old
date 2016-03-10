module Bozzuto::Searches
  module Exact
    class Search < SearchBase
      # Exact searches return results matching exactly the given criteria.
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
      #     INNER JOIN (
      #       SELECT apartment_community_id, GROUP_CONCAT(
      #             DISTINCT floor_plan_group_id
      #             ORDER BY floor_plan_group_id
      #         ) AS search_values
      #       FROM apartment_floor_plans
      #       GROUP BY apartment_community_id
      #     ) AS associated
      #     ON associated.apartment_community_id = apartment_communities.id
      #     WHERE associated.search_values LIKE ?
      #   )

      def values
        @ids ||= if input.any?
          main_class.sanitize input.sort.join(',')
        else
          '?'
        end
      end

      private

      def join_clause
        Arel.sql("(#{associated_values.to_sql})").as(derived_table.name)
      end

      def derived_table
        @derived_table ||= Arel::Table.new('associated')
      end

      def associated_fields
        [foreign_key, grouped_values]
      end

      def associated_values
        associated_table
          .project(*associated_fields)
          .group(foreign_key)
      end

      def values_alias
        Arel.sql('search_values')
      end

      def grouped_values
        Arel.sql(values_list).as(values_alias)
      end

      def values_list
        %Q(
          GROUP_CONCAT(
            DISTINCT #{search_column}
            ORDER BY #{search_column}
          )
        )
      end

      def join_condition
        main_table[:id].eq derived_table[foreign_key]
      end

      def where_condition
        derived_table[values_alias].matches Arel.sql(values)
      end
    end
  end
end
