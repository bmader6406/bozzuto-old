require 'test_helper'

class GreenFeatureTest < ActiveSupport::TestCase
  subject { GreenFeature.make }

  should have_many(:green_package_items).dependent(:destroy)

  should validate_presence_of(:title)

  should validate_attachment_presence(:photo)

  context "#to_s" do
    it "returns the title" do
      subject.to_s.should == subject.title
    end
  end
end
