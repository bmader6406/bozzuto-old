require 'test_helper'

class PropertySlideTest < ActiveSupport::TestCase
  context 'PropertySlide' do
    should belong_to(:property_slideshow)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    should validate_length_of(:caption).is_at_least(0).is_at_most(128)

    describe "#typus_name" do
      subject do
        PropertySlide.new(
          :property_slideshow => PropertySlideshow.new(:name => 'Slideshow'),
          :position           => 3
        )
      end

      it "returns the slideshow name and position" do
        subject.typus_name.should == 'Slideshow - Slide #3'
      end
    end
  end
end
