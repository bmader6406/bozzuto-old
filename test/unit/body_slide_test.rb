require 'test_helper'

class BodySlideTest < ActiveSupport::TestCase
  context 'BodySlide' do
    should belong_to(:body_slideshow)
    should belong_to(:property)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)
  end
end
