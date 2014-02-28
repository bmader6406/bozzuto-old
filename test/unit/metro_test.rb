require 'test_helper'

class MetroTest < ActiveSupport::TestCase
  context "A Metro" do
    subject { Metro.make }

    should_validate_presence_of(:name)
    should_validate_presence_of(:latitude)
    should_validate_presence_of(:longitude)

    should_validate_uniqueness_of(:name)

    should_validate_attachment_presence(:listing_image)
  end
end
