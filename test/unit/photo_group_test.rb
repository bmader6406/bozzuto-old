require 'test_helper'

class PhotoGroupTest < ActiveSupport::TestCase
  context 'PhotoGroup' do
    subject { PhotoGroup.new(title: 'cat pics') }

    should have_many(:photos)

    should validate_presence_of(:title)

    describe "#to_s" do
      it "returns the title" do
        subject.to_s.should == 'cat pics'
      end
    end

    describe "#to_label" do
      it "returns the title" do
        subject.to_label.should == 'cat pics'
      end
    end
  end
end
