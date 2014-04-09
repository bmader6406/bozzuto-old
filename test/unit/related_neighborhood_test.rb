require 'test_helper'

class RelatedNeighborhoodTest < ActiveSupport::TestCase
  context "A Related Neighborhood" do
    subject { RelatedNeighborhood.make }

    should_belong_to(:neighborhood)
    should_belong_to(:nearby_neighborhood)

    should_validate_presence_of(:neighborhood)
    should_validate_presence_of(:nearby_neighborhood)
    should_validate_uniqueness_of(:nearby_neighborhood_id, :scoped_to => :neighborhood_id)

    describe "validating" do
      context "nearby_neighborhood is the same as neighborhood" do
        before do
          subject.nearby_neighborhood = subject.neighborhood
        end

        it "has an error message on nearby_neighborhood" do
          subject.valid?.should == false

          subject.errors.on(:nearby_neighborhood).should == "can't be the same as Neighborhood"
        end
      end
    end
  end
end
