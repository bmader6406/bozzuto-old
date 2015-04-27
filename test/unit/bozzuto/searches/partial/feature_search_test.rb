require 'test_helper'

module Bozzuto::Searches::Partial
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Partial::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN properties_property_features
              ON properties.id = properties_property_features.property_id
              WHERE properties_property_features.property_feature_id IN (?)
            )
          ))
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([5,2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN properties_property_features
              ON properties.id = properties_property_features.property_id
              WHERE properties_property_features.property_feature_id IN (5,2,4)
            )
          ))
        end
      end
    end
  end
end
