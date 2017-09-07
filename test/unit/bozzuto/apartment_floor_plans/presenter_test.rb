require 'test_helper'

module Bozzuto::ApartmentFloorPlans
  class ApartmentFloorPlanPresenterTest < ActiveSupport::TestCase
    context "ApartmentFloorPlanPresenter" do
      before do
        @studio      = ApartmentFloorPlanGroup.make(:studio)
        @one_bedroom = ApartmentFloorPlanGroup.make(:one_bedroom)
        @community   = ApartmentCommunity.make
      end

      subject { Presenter.new(@community) }

      describe "#has_plans?" do
        context "any of the groups has plans" do
          before do
            @plan = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :floor_plan_group    => @studio
            )
          end

          it "returns true" do
            subject.has_plans?.should == true
          end
        end

        context "none of the groups has any plans" do
          it "returns false" do
            subject.has_plans?.should == false
          end
        end
      end

      context "FloorPlanGroup" do
        subject { Presenter::FloorPlanGroup.new(@community, @studio) }

        describe "#name" do
          before do
            @studio.expects(:plural_name).returns('Hooray')
          end

          it "returns the plural_name" do
            subject.name.should == 'Hooray'
          end
        end

        describe "#has_plans?" do
          context "the group has plans" do
            before do
              @plan = ApartmentFloorPlan.make(
                :apartment_community => @community,
                :floor_plan_group    => @studio
              )
            end

            it "returns true" do
              subject.has_plans?.should == true
            end
          end

          context "the group doesn't have plans" do
            it "returns false" do
              subject.has_plans?.should == false
            end
          end
        end

        describe "#largest_square_footage" do
          before do
            @largest = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :floor_plan_group    => @studio,
              :max_square_feet     => 1000,
              :min_square_feet     => 900
            )

            @smallest = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :floor_plan_group    => @studio,
              :max_square_feet     => 500,
              :min_square_feet     => 400
            )
          end

          it "returns the square footage" do
            subject.largest_square_footage.should == 900
          end
        end

        describe "#cheapest_rent" do
          before do
            @most_expensive = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :floor_plan_group    => @studio,
              :min_rent            => 1000
            )

            @cheapest = ApartmentFloorPlan.make(
              :apartment_community => @community,
              :floor_plan_group    => @studio,
              :min_rent            => 700
            )
          end

          it "returns the cheapest rent" do
            subject.cheapest_rent.should == 700
          end
        end

        describe "#cheapest_floor_plan" do
          before do
            @target = ApartmentFloorPlan.make(
              apartment_community: @community,
              floor_plan_group:    @studio,
              min_square_feet:     900,
              min_rent:            1100
            )

            @fluff = ApartmentFloorPlan.make(
              apartment_community: @community,
              floor_plan_group:    @studio,
              min_square_feet:     950,
              min_rent:            1150
            )

            @cruft = ApartmentFloorPlan.make(
              apartment_community: @community,
              floor_plan_group:    @studio,
              min_square_feet:     1000,
              min_rent:            nil
            )
          end

          it "returns the floor plan with the cheapest rent" do
            subject.cheapest_floor_plan.should == @target
          end
        end
      end
    end
  end
end
