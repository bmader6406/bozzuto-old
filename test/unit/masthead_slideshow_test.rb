require 'test_helper'

class MastheadSlideshowTest < ActiveSupport::TestCase
  context 'MastheadSlideshow' do
    should belong_to(:page)
    should have_many(:slides)

    should validate_presence_of(:name)

    describe "#to_s" do
      it "returns the name" do
        subject.to_s.should == subject.name
      end
    end

    describe "#diff_attributes" do
      before do
        @representation = mock('Chronolog::DiffRepresentation')

        Chronolog::DiffRepresentation.stubs(:new).with(subject, includes: :slides).returns(@representation)
      end

      it "includes its slides in its diff representation" do
        @representation.expects(:attributes)

        subject.diff_attributes
      end
    end
  end
end
