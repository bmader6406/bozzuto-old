require 'test_helper'

class CarouselTest < ActiveSupport::TestCase
  context 'A carousel' do
    should validate_presence_of(:name)

    should belong_to(:content)

    should accept_nested_attributes_for(:panels)

    describe "#to_s" do
      it "returns the name" do
        subject.to_s.should == subject.name
      end
    end

    describe "#diff_attributes" do
      before do
        @representation = mock('Chronolog::DiffRepresentation')

        Chronolog::DiffRepresentation.stubs(:new).with(subject, includes: :panels).returns(@representation)
      end

      it "includes its panels in its diff representation" do
        @representation.expects(:attributes)

        subject.diff_attributes
      end
    end
  end
end
