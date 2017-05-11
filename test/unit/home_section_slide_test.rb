require 'test_helper'

class HomeSectionSlideTest < ActiveSupport::TestCase
  context "HomeSectionSlide" do
    should belong_to(:home_page)
    
    describe "#to_s" do
      before do
        @without_text = HomeSectionSlide.make(text: nil, link_url: 'https://test.com')
        @with_text    = HomeSectionSlide.make(text: 'Test', link_url: 'https://test.com')
      end

      it "returns the text, url, or class name and ID" do
        @without_text.to_s.should == "https://test.com"
        @with_text.to_s.should == "Test"
      end
    end
  end
end
