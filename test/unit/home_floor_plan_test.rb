require 'test_helper'

class HomeFloorPlanTest < ActiveSupport::TestCase
  context "HomeFloorPlan" do
    subject { HomeFloorPlan.make }

    should belong_to(:home)

    should validate_presence_of(:name)

    should have_attached_file(:image)
    should validate_attachment_presence(:image)

    describe "#actual_image" do
      it "returns the image url" do
        subject.actual_image.should =~ /original\.jpg/
      end
    end

    describe "#actual_thumb" do
      it "returns the thumb url" do
        subject.actual_thumb.should =~ /thumb\.jpg/
      end
    end
  end
end
