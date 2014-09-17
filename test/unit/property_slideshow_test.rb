require 'test_helper'

class PropertySlideshowTest < ActiveSupport::TestCase
  context 'PropertySlideshow' do
    should validate_presence_of(:name)

    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)
    should belong_to(:project)
  end
end
