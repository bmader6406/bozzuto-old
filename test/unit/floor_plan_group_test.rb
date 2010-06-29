require 'test_helper'

class FloorPlanGroupTest < ActiveSupport::TestCase
  context "A floor plan group" do
    setup do
      @group = FloorPlanGroup.make
    end

    should_have_many :floor_plans

    should_validate_presence_of :name
  end
end
