require 'test_helper'

module Bozzuto::Searches::Full
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Full::FeatureSearch" do
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
              WHERE associated.search_values
              REGEXP ?
            )
          ))
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([2,4]) }

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
              WHERE associated.search_values
              REGEXP '(2|,2|2,|,2,){1}([[:digit:]]|,[[:digit:]]|[[:digit:]],|,[[:digit:]],)*(4|,4|4,|,4,){1}'
            )
          ))
        end
      end
    end
  end
end
