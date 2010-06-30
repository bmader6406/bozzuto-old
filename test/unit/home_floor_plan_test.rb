require 'test_helper'

class HomeFloorPlanTest < ActiveSupport::TestCase
  context 'HomeFloorPlan' do
    should_belong_to :home

    should_validate_presence_of :name
    should_have_attached_file :image
    should_validate_attachment_presence :image
  end
end
