require 'test_helper'

module Bozzuto::Searches::Partial
  class FloorPlanSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Partial::FloorPlanSearch" do
      subject { FloorPlanSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN apartment_floor_plans
              ON properties.id = apartment_floor_plans.apartment_community_id
              AND apartment_floor_plans.available_units > 0
              WHERE apartment_floor_plans.floor_plan_group_id IN (?)
            )
          ))
        end
      end

      describe "#sql" do
        subject { FloorPlanSearch.new([5,2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          sqlized(subject.sql).should == sqlized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN apartment_floor_plans
              ON properties.id = apartment_floor_plans.apartment_community_id
              AND apartment_floor_plans.available_units > 0
              WHERE apartment_floor_plans.floor_plan_group_id IN (5,2,4)
            )
          ))
        end
      end
    end
  end
end
