require 'test_helper'

class CityTest < ActiveSupport::TestCase
  context "A city" do
    setup do
      @city = City.make
    end

    should "print out its name and state name on #to_s" do
      assert_equal "#{@city.name}, #{@city.state.code}", @city.to_s
    end
  end
end
