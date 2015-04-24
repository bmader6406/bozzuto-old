require 'test_helper'

module Bozzuto::Searches::Inclusive
  class FloorPlanSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Inclusive::FloorPlanSearch" do
      subject { FloorPlanSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN apartment_floor_plans
              ON properties.id = apartment_floor_plans.apartment_community_id
              WHERE apartment_floor_plans.floor_plan_group_id IN (?)
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
        subject { FloorPlanSearch.new([5,2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN apartment_floor_plans
              ON properties.id = apartment_floor_plans.apartment_community_id
              WHERE apartment_floor_plans.floor_plan_group_id IN (5,2,4)
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
