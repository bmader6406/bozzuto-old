module Bozzuto
  module Searches
    class InclusiveValueSearch
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

      QUERY = %Q(
        properties.id IN (
          SELECT properties.id
          FROM properties
          INNER JOIN apartment_floor_plans
          ON apartment_floor_plans.apartment_community_id = properties.id
          WHERE apartment_floor_plans.floor_plan_group_id IN (?)
        )
      )

  scope :with_floor_plan_groups, lambda { |ids|
    {:conditions => ["properties.id IN (SELECT apartment_community_id FROM apartment_floor_plans WHERE floor_plan_group_id IN (?))", Array(ids)]}
  }

  scope :with_property_features, lambda { |ids|
    {:conditions => ["properties.id IN (SELECT property_id FROM properties_property_features WHERE property_feature_id IN (?))", Array(ids)]}
  }
      def self.sql
        new.sql
      end

      attr_reader :input

      def initialize(input = nil)
        @input = Array(input)
      end

      def main_class
        raise NotImplementedError
      end

      def associated_class
        raise NotImplementedError
      end

      def foreign_key
        raise NotImplementedError
      end

      def search_column
        raise NotImplementedError
      end

      def values
        @ids ||= if input.any?
          main_class.sanitize input.sort.join(',')
        else
          '?'
        end
      end

      def sql
        query.to_sql
      end

      private

      def main_table
        @main_table ||= main_class.arel_table
      end

      def associated_table
        @associated_table ||= associated_class.arel_table
      end

      def query
        main_table[:id].in(records_matching_values)
      end

      def records_matching_values
        main_table
          .project(:id)
          .join(subquery)
          .on(matching_ids)
          .where(values_match)
      end

      def subquery
        Arel.sql("(#{associated_values.to_sql})").as(derived_table)
      end

      def associated_values
        associated_table
          .project(foreign_key, grouped_values)
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

      def fk_with_table
        Arel.sql [
          derived_table_name,
          foreign_key
        ].join('.')
      end

      def derived_table_name
        'associated'
      end

      def derived_table
        Arel.sql('associated')
      end

      def matching_ids
        fk_with_table.eq main_table[:id]
      end

      def derived_values
        Arel.sql [
          derived_table_name,
          values_alias
        ].join('.')
      end

      def values_match
        derived_values.matches Arel.sql(values)
      end
    end
  end
end
