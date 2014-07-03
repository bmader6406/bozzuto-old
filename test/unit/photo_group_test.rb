require 'test_helper'

class PhotoGroupTest < ActiveSupport::TestCase
  context 'PhotoGroup' do
    should_have_many :photos

    should_validate_presence_of :title

    describe "#typus_name" do
      subject { PhotoGroup.make(:title => 'cat pics') }

      it "returns the title" do
        subject.typus_name.should == 'cat pics'
      end
    end
  end
end
