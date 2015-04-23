require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context 'Video' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)

    should validate_presence_of(:url)

    should have_attached_file(:image)

    describe "#typus_name" do
      subject do
        Video.new(
          :property => Property.new(:title => 'Wayne Manor'),
          :position => 9
        )
      end

      it "returns the property title and position" do
        subject.typus_name.should == 'Wayne Manor - Video #9'
      end

      context "when the video does not have a property" do
        subject { Video.make(:property => nil) }

        it "returns the name of the model along with its ID" do
          subject.typus_name.should == "Video ##{subject.id}"
        end
      end
    end
  end
end
