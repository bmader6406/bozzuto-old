require 'test_helper'

class PropertySlideTest < ActiveSupport::TestCase
  context 'PropertySlide' do
    should_belong_to :property_slideshow

    should_have_attached_file :image

    should_validate_attachment_presence :image
  end
end
