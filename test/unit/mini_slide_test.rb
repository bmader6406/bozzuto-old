require 'test_helper'

class MiniSlideTest < ActiveSupport::TestCase
  context 'MiniSlide' do
    should belong_to(:mini_slideshow)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    describe "#to_s" do
      subject do
        MiniSlide.new(
          :mini_slideshow => MiniSlideshow.new(:title => 'Slideshow'),
          :position           => 7
        )
      end

      it "returns the slideshow title and slide position" do
        subject.to_s.should == 'Slideshow - Slide #7'
      end
    end
  end
end
