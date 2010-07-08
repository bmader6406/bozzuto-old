require 'test_helper'

class ApartmentFloorPlanGroupTest < ActiveSupport::TestCase
  context "ApartmentFloorPlanGroup" do
    setup do
      @group = ApartmentFloorPlanGroup.make
    end

    should_have_many :floor_plans

    should_validate_presence_of :name
  end
end
