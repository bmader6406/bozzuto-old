require 'test_helper'

class PropertySlideTest < ActiveSupport::TestCase
  context 'PropertySlide' do
    should belong_to(:property_slideshow)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    should validate_length_of(:caption).is_at_most(128)

    describe "#to_s" do
      context "with a property slideshow" do
        subject do
          PropertySlide.new(
            :property_slideshow => PropertySlideshow.new(:name => 'Slideshow'),
            :position           => 3
          )
        end

        it "returns the slideshow name and position" do
          subject.to_s.should == 'Slideshow - Slide #3'
        end
      end

      context "without a property slideshow" do
        subject do
          PropertySlide.new(
            :property_slideshow => nil,
            :position           => 3
          )
        end

        it "returns the slideshow name and position" do
          subject.to_s.should == 'Slide #3'
        end
      end
    end
  end
end
