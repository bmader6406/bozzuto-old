require 'test_helper'

class CityTest < ActiveSupport::TestCase
  context "A city" do
    setup do
      @city = City.make
    end

    subject { @city }

    should_have_many :communities
    should_belong_to :state

    should_validate_presence_of :name, :state
    should_validate_uniqueness_of :name, :scoped_to => :state_id

    should "print out its name and state name on #to_s" do
      assert_equal "#{@city.name}, #{@city.state.code}", @city.to_s
    end
  end
end
