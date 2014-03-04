require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  context "An Area" do
    subject { Area.make }

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)
    should_validate_presence_of(:metro)

    should_validate_uniqueness_of(:name)

    should_validate_attachment_presence(:listing_image)

    should_belong_to(:metro)
  end
end
