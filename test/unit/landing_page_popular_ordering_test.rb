require 'test_helper'

class LandingPagePopularOrderingTest < ActiveSupport::TestCase
  context 'LandingPagePopularOrdering' do
    should belong_to(:landing_page)
    should belong_to(:property)
  end
end
