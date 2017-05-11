require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should have_many(:slides)
    should have_one(:carousel)

    should validate_presence_of(:body)

    should have_attached_file(:body_sub_image)
    should have_attached_file(:mobile_banner_image)

    describe "#to_s" do
      it "returns 'Home Page'" do
        HomePage.new.to_s.should == 'Home Page'
      end
    end

    describe "#to_label" do
      it "returns 'Home Page'" do
        HomePage.new.to_label.should == 'Home Page'
      end
    end

    describe "#diff_attributes" do
      before do
        @representation = mock('Chronolog::DiffRepresentation')

        Chronolog::DiffRepresentation.stubs(:new).with(subject, includes: [:carousel, :slides]).returns(@representation)
      end

      it "includes its slides in its diff representation" do
        @representation.expects(:attributes)

        subject.diff_attributes
      end
    end
  end
end
