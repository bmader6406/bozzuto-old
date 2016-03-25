require 'test_helper'

class MiniSlideshowTest < ActiveSupport::TestCase
  context 'MiniSlideshow' do
    should validate_presence_of(:title)
    should validate_presence_of(:link_url)

    describe "#to_s" do
      it "returns the title" do
        subject.to_s.should == subject.title
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
