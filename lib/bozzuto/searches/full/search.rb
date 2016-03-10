module Bozzuto::Searches
  module Full
    class Search < Exact::Search
      # Full searches return results matching all the given criteria at a minimum.
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
      #     WHERE associated.search_values
      #     REGEXP ?
      #   )

      def values
        @values ||= if input.any?
          main_class.sanitize input.sort.map { |value| value_regex(value) }.join(filler_regex)
        else
          '?'
        end
      end

      private

      def regex_partial(value, frequency = '*')
        "(#{value},|#{value}$)#{frequency}"
      end

      def filler_regex
        regex_partial '[[:digit:]]+'
      end

      def value_regex(value)
        regex_partial value, '{1}'
      end

      def where_condition
        Arel::Nodes::InfixOperation.new('REGEXP', derived_table[values_alias], Arel.sql(values))
      end
    end
  end
end
