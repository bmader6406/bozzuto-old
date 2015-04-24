module Bozzuto
  module Searches
    class FeatureSearch < ExclusiveValueSearch
      def main_class
        Property
      end

      def foreign_key
        'property_id'
      end

      def search_column
        'property_feature_id'
      end

      private

      def associated_table
        @associated_table ||= Arel::Table.new(:properties_property_features)
      end
    end
  end
end
