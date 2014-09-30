require 'test_helper'

class BodySlideTest < ActiveSupport::TestCase
  context 'BodySlide' do
    should belong_to(:body_slideshow)
    should belong_to(:property)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    describe "#typus_name" do
      subject do
        BodySlide.new(
          :body_slideshow => BodySlideshow.new(:name => 'The Slideshow'),
          :position       => 5
        )
      end

      it "returns the slideshow name and the position" do
        subject.typus_name.should == 'The Slideshow - Slide #5'
      end
    end
  end
end
