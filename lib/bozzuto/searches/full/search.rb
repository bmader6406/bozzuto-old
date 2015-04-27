module Bozzuto::Searches
  module Full
    class Search < Exact::Search
      # Full searches return results matching all the given criteria at a minimum.
      #
      # SQL output given the following:
      #   main_class       == Property
      #   associated_class == ApartmentFloorPlan
      #   foreign_key      == 'apartment_community_id'
      #   search_column    == 'floor_plan_group_id'
      #
      #   properties.id IN (
      #     SELECT properties.id
      #     FROM properties
      #     INNER JOIN (
      #       SELECT apartment_community_id, GROUP_CONCAT(
      #             DISTINCT floor_plan_group_id
      #             ORDER BY floor_plan_group_id
      #         ) AS search_values
      #       FROM apartment_floor_plans
      #       GROUP BY apartment_community_id
      #     ) AS associated
      #     ON associated.apartment_community_id = properties.id
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
        Arel.sql [
          derived_values,
          values
        ].join(' REGEXP ')
      end
    end
  end
end
