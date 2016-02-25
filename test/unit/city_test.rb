require 'test_helper'

class CityTest < ActiveSupport::TestCase
  context 'City' do
    setup do
      @state = State.make(code: "CO")
      @city  = City.make(name: "Boulder", state: @state)
    end

    subject { @city }

    should belong_to(:state)

    should have_many(:apartment_communities)
    should have_many(:home_communities)
    should have_many(:communities)

    should have_and_belong_to_many(:counties)

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name).scoped_to(:state_id)

    should validate_presence_of(:state)

    describe "#to_s" do
      it "returns the name and state code" do
        subject.to_s.should == "Boulder, CO"
      end
    end

    describe "#to_label" do
      it "returns the name and state code" do
        subject.to_label.should == "Boulder, CO"
      end
    end
  end
end
