require 'test_helper'

class LandingPagePopularOrderingTest < ActiveSupport::TestCase
  context 'LandingPagePopularOrdering' do
    should_belong_to :landing_page, :property
  end
end
