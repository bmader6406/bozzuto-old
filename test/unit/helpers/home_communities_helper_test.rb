require 'test_helper'

class HomeCommunitiesHelperTest < ActionView::TestCase
  context '#zillow_mortgage_calculator' do
    should 'return the Zillow code' do
      assert_match /Zillow/, zillow_mortgage_calculator
    end

    should 'be marked html_safe' do
      assert zillow_mortgage_calculator.html_safe?
    end
  end
end
