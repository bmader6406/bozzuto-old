require 'test_helper'

class CityTest < ActiveSupport::TestCase
  context 'City' do
    setup do
      @city = City.make
    end

    subject { @city }

    should have_many(:apartment_communities)
    should have_many(:home_communities)
    should have_many(:communities)
    should belong_to(:state)
    should have_and_belong_to_many(:counties)

    should validate_presence_of(:name)
    should validate_presence_of(:state)
    should validate_uniqueness_of(:name).scoped_to(:state_id)

    should "print out its name and state name on #to_s" do
      assert_equal "#{@city.name}, #{@city.state.code}", @city.to_s
    end
  end
end
