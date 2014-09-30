require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should have_many(:slides)
    should have_one(:carousel)

    should validate_presence_of(:body)

    should have_attached_file(:mobile_banner_image)

    describe "#typus_name" do
      subject { HomePage.new }

      it "returns 'Home Page'" do
        subject.typus_name.should == 'Home Page'
      end
    end
  end
end
