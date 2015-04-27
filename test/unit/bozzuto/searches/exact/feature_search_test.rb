require 'test_helper'

module Bozzuto::Searches::Exact
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Exact::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
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

      describe "#sql" do
        subject { FeatureSearch.new([2,4,5]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
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
  end
end
