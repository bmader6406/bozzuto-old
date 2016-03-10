require 'test_helper'

module Bozzuto::Searches::Partial
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Partial::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            apartment_communities.id IN (
              SELECT apartment_communities.id
              FROM apartment_communities
              INNER JOIN property_feature_attributions
              ON apartment_communities.id = property_feature_attributions.property_id AND property_feature_attributions.property_type = 'ApartmentCommunity'
              WHERE property_feature_attributions.property_feature_id IN (?)
            )
          ))
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([5,2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            apartment_communities.id IN (
              SELECT apartment_communities.id
              FROM apartment_communities
              INNER JOIN property_feature_attributions
              ON apartment_communities.id = property_feature_attributions.property_id AND property_feature_attributions.property_type = 'ApartmentCommunity'
              WHERE property_feature_attributions.property_feature_id IN (5,2,4)
            )
          ))
        end
      end
    end
  end
end
