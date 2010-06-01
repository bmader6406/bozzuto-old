require 'test_helper'

class FloorPlanGroupTest < ActiveSupport::TestCase
  context "A floor plan group" do
    should_have_many :floor_plans
    should_belong_to :community

    should_validate_presence_of :name
  end
end
