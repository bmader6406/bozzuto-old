require 'test_helper'

class NeighborhoodTest < ActiveSupport::TestCase
  context "A Neighborhood" do
    subject { Neighborhood.make }

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)
    should_validate_presence_of(:area)
    should_validate_presence_of(:state)

    should_validate_uniqueness_of(:name)

    should_validate_attachment_presence(:listing_image)
    should_validate_attachment_presence(:banner_image)

    should_belong_to(:area)
    should_belong_to(:state)
  end
end
