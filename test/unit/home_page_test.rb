require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should have_many(:slides)
    should have_one(:carousel)

    should validate_presence_of(:body)

    should have_attached_file(:mobile_banner_image)

    describe "#to_s" do
      it "returns 'Home Page'" do
        HomePage.new.to_s.should == 'Home Page'
      end
    end
  end
end
