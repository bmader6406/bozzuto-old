module Bozzuto::Searches
  module Full
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

      def associated_table
        @associated_table ||= Arel::Table.new(:property_feature_attributions)
      end
    end
  end
end
