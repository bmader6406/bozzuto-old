require 'test_helper'

class HomePageSlideTest < ActiveSupport::TestCase
  context 'HomePageSlide' do
    should belong_to(:home_page)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    describe "#typus_name" do
      subject { HomePageSlide.new(:position => 3) }

      it "returns 'Home Page' and the slide number" do
        subject.typus_name.should == 'Home Page - Slide #3'
      end
    end
  end
end
