module Bozzuto
  module Searches
    class SearchBase
      def self.sql
        new.sql
      end

      attr_reader :input

      def initialize(input = nil)
        @input = Array(input).map do |id|
          # Ransack converts 1's and 0's passed into `.search` into true/false
          # https://github.com/activerecord-hackery/ransack/issues/593
          id == true ? 1 : id.to_i
        end
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
        @ids ||= input.any? ? input.join(',') : '?'
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
        main_table[:id].in(matching_result_set)
      end

      def matching_result_set
        main_table
          .project(main_table[:id])
          .join(join_clause)
          .on(join_condition)
          .where(where_condition)
      end

      def join_clause
        raise NotImplementedError
      end

      def join_condition
        main_table[:id].eq associated_table[foreign_key]
      end

      def where_condition
        raise NotImplementedError
      end
    end
  end
end
