require 'test_helper'

class LandingPagePopularPropertyTest < ActiveSupport::TestCase
  context 'LandingPagePopularProperty' do
    should_belong_to :landing_page, :property
  end
end