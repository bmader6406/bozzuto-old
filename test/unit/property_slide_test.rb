require 'test_helper'

class PropertySlideTest < ActiveSupport::TestCase
  context 'PropertySlide' do
    should belong_to(:property_slideshow)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    should ensure_length_of(:caption).is_at_least(0).is_at_most(128)
  end
end
