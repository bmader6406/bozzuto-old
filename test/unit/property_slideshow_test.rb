require 'test_helper'

class PropertySlideshowTest < ActiveSupport::TestCase
  context 'PropertySlideshow' do
    should_validate_presence_of :name
    should_belong_to :property, :apartment_community, :home_community, :project
  end
end
