require 'test_helper'

class ApartmentFloorPlanObserverTest < ActiveSupport::TestCase
  context 'Apartment floor plan observer' do
    setup do
      @community = ApartmentCommunity.make
    end

    [['studio', 'studio'], ['one_bedroom', '1_bedroom'], ['two_bedrooms', '2_bedroom'], ['three_bedrooms', '3_bedroom'], ['penthouse', 'penthouse']].each do |group|
      context "when saving a #{group[0]} floor plan" do
        setup do
          @group = ApartmentFloorPlanGroup.send(group[0])
          @plan = ApartmentFloorPlan.make_unsaved(
            :floor_plan_group    => @group,
            :apartment_community => @community
          )
        end

        should 'update the cache column on community' do
          attr = "cheapest_#{group[1]}_price"
          assert_nil @community.send(attr)

          @plan.save
          @community.reload

          assert_equal @plan.min_rent.to_s, @community.send(attr)
        end
      end
    end
  end
end
