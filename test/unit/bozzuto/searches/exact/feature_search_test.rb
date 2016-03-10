require 'test_helper'

module Bozzuto::Searches::Exact
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Exact::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            apartment_communities.id IN (
              SELECT apartment_communities.id
              FROM apartment_communities
              INNER JOIN (
                SELECT property_id, GROUP_CONCAT(
                      DISTINCT property_feature_id
                      ORDER BY property_feature_id
                  ) AS search_values, property_type
                FROM property_feature_attributions
                GROUP BY property_id
              ) AS associated
              ON apartment_communities.id = associated.property_id AND associated.property_type = 'ApartmentCommunity'
              WHERE associated.search_values LIKE ?
            )
          ))
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([2,4,5]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            apartment_communities.id IN (
              SELECT apartment_communities.id
              FROM apartment_communities
              INNER JOIN (
                SELECT property_id, GROUP_CONCAT(
                      DISTINCT property_feature_id
                      ORDER BY property_feature_id
                  ) AS search_values, property_type
                FROM property_feature_attributions
                GROUP BY property_id
              ) AS associated
              ON apartment_communities.id = associated.property_id AND associated.property_type = 'ApartmentCommunity'
              WHERE associated.search_values LIKE '2,4,5'
            )
          ))
        end
      end
    end
  end
end
