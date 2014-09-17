require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  context 'A County' do
    subject { County.make }

    should belong_to(:state)
    should have_and_belong_to_many(:cities)
    should have_many(:apartment_communities)
    should have_many(:home_communities)

    should validate_presence_of(:name)
    should validate_presence_of(:state)
    should validate_uniqueness_of(:name).scoped_to(:state_id)

    describe "#to_s" do
      it "return the county name and state" do
        subject.to_s.should == "#{subject.name}, #{subject.state.code}"
      end
    end
  end
end
