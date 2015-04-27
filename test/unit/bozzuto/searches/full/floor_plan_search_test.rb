require 'test_helper'

module Bozzuto::Searches::Full
  class FloorPlanSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Full::FloorPlanSearch" do
      subject { FloorPlanSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN (
                SELECT apartment_community_id, GROUP_CONCAT(
                      DISTINCT floor_plan_group_id
                      ORDER BY floor_plan_group_id
                  ) AS search_values
                FROM apartment_floor_plans
                GROUP BY apartment_community_id
              ) AS associated
              ON associated.apartment_community_id = properties.id
              WHERE associated.search_values
              REGEXP ?
            )
          ))
        end
      end

      describe "#sql" do
        subject { FloorPlanSearch.new([2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN (
                SELECT apartment_community_id, GROUP_CONCAT(
                      DISTINCT floor_plan_group_id
                      ORDER BY floor_plan_group_id
                  ) AS search_values
                FROM apartment_floor_plans
                GROUP BY apartment_community_id
              ) AS associated
              ON associated.apartment_community_id = properties.id
              WHERE associated.search_values
              REGEXP '(2,|2$){1}([[:digit:]]+,|[[:digit:]]+$)*(4,|4$){1}'
            )
          ))
        end
      end
    end
  end
end
