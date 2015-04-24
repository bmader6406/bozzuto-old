require 'test_helper'

module Bozzuto::Searches
  class FloorPlanSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::FloorPlanSearch" do
      subject { FloorPlanSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT id
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

      describe "#associated_class" do
        it "returns the associated class" do
          subject.associated_class.should == ApartmentFloorPlan
        end
      end

      describe "#foreign_key" do
        it "returns the foreign key" do
          subject.foreign_key.should == 'apartment_community_id'
        end
      end

      describe "#search_column" do
        it "returns the search column" do
          subject.search_column.should == 'floor_plan_group_id'
        end
      end

      describe "#sql" do
        subject { FloorPlanSearch.new([2,4,5]) }

        it "returns exclusive search SQL with the given expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT id
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
