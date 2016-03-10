module Bozzuto::Searches
  module Partial
    class FeatureSearch < Search
      include Bozzuto::Searches::PolymorphicJoin

      def main_class
        ApartmentCommunity
      end

      def foreign_key
        'property_id'
      end

      def search_column
        'property_feature_id'
      end

      private

      def join_condition
        super.and associated_table[foreign_key_type].eq(main_class.name)
      end

      def associated_table
        @associated_table ||= Arel::Table.new(:property_feature_attributions)
      end
    end
  end
end
