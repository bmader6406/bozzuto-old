require 'test_helper'

class FloorPlanGroupsHelperTest < ActionView::TestCase
  context 'FloorPlanGroupsHelper' do
    context '#floor_plan_bedrooms' do
      should 'properly pluralize the bedrooms count' do
        @plan = FloorPlan.new :bedrooms => 1
        assert_equal '1 Bedroom', floor_plan_bedrooms(@plan)
        @plan.bedrooms = 2
        assert_equal '2 Bedrooms', floor_plan_bedrooms(@plan)
      end
    end

    context '#floor_plan_bathrooms' do
      should 'properly pluralize the bathrooms count' do
        @plan = FloorPlan.new :bathrooms => 1
        assert_equal '1 Bathroom', floor_plan_bathrooms(@plan)
        @plan.bathrooms = 2.5
        assert_equal '2.5 Bathrooms', floor_plan_bathrooms(@plan)
      end
    end
  end
end
