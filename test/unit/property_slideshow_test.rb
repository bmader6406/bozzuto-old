require 'test_helper'

class PropertySlideshowTest < ActiveSupport::TestCase
  context 'PropertySlideshow' do
    should belong_to(:property)

    should have_many(:slides)

    should validate_presence_of(:name)
  end
end
