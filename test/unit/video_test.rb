require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context 'Video' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)

    should validate_presence_of(:url)

    should have_attached_file(:image)

    describe "#to_s" do
      context "when the video has a property" do
        subject do
          Video.new(
            :property => Property.new(:title => 'Wayne Manor'),
            :position => 9
          )
        end

        it "returns the property title and position" do
          subject.to_s.should == 'Wayne Manor - Video #9'
        end
      end

      context "when the video does not have a property" do
        subject do
          Video.make(:property => nil)
        end

        it "returns the name of the model along with its ID" do
          subject.to_s.should == "Video ##{subject.id}"
        end
      end
    end
  end
end
