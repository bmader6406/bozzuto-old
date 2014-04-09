require 'test_helper'

class RelatedAreaTest < ActiveSupport::TestCase
  context "A Related Area" do
    subject { RelatedArea.make }

    should_belong_to(:area)
    should_belong_to(:nearby_area)

    should_validate_presence_of(:area)
    should_validate_presence_of(:nearby_area)
    should_validate_uniqueness_of(:nearby_area_id, :scoped_to => :area_id)

    describe "validating" do
      context "nearby_area is the same as area" do
        before do
          subject.nearby_area = subject.area
        end

        it "has an error message on nearby_area" do
          subject.valid?.should == false

          subject.errors.on(:nearby_area).should == "can't be the same as Area"
        end
      end
    end
  end
end
