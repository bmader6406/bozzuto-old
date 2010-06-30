require 'test_helper'

class PropertySlideshowTest < ActiveSupport::TestCase
  context 'PropertySlideshow' do
    should_validate_presence_of :name
    should_belong_to :property
  end
end
