require 'test_helper'

class ApartmentFloorPlanObserverTest < ActiveSupport::TestCase
  context 'Apartment floor plan observer' do
    setup do
      @community = ApartmentCommunity.make
    end

    groups = [['studio', 'studio'], ['one_bedroom', '1_bedroom'], ['two_bedrooms', '2_bedroom'], ['three_bedrooms', '3_bedroom'], ['penthouse', 'penthouse']]

    groups.each do |group|
      describe "saving a #{group[0]} floor plan" do
        setup do
          @group = ApartmentFloorPlanGroup.send(group[0])
          @plan = ApartmentFloorPlan.make_unsaved(
            :floor_plan_group    => @group,
            :apartment_community => @community
          )
        end

        it "updates the cache column on community" do
          attr = "cheapest_#{group[1]}_price"
          @community.send(attr).should == nil

          @plan.save
          @community.reload

          @community.send(attr).should == @plan.min_rent.to_s
        end
      end
    end
  end
end
