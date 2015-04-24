require 'test_helper'

module Bozzuto::Searches
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT id
              FROM properties
              INNER JOIN (
                SELECT property_id, GROUP_CONCAT(
                      DISTINCT property_feature_id
                      ORDER BY property_feature_id
                  ) AS search_values
                FROM properties_property_features
                GROUP BY property_id
              ) AS associated
              ON associated.property_id = properties.id
              WHERE associated.search_values LIKE ?
            )
          ))
        end
      end

      describe "#main_class" do
        it "returns the main class" do
          subject.main_class.should == Property
        end
      end

      describe "#foreign_key" do
        it "returns the foreign key" do
          subject.foreign_key.should == 'property_id'
        end
      end

      describe "#search_column" do
        it "returns the search column" do
          subject.search_column.should == 'property_feature_id'
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([2,4,5]) }

        it "returns exclusive search SQL with the given expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT id
              FROM properties
              INNER JOIN (
                SELECT property_id, GROUP_CONCAT(
                      DISTINCT property_feature_id
                      ORDER BY property_feature_id
                  ) AS search_values
                FROM properties_property_features
                GROUP BY property_id
              ) AS associated
              ON associated.property_id = properties.id
              WHERE associated.search_values LIKE '2,4,5'
            )
          ))
        end
      end
    end

    # Take spacing and backticks out of the equation
    def equalized(string)
      string.gsub(/[\s`]/, '')
    end
  end
end
