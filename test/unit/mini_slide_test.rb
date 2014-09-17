require 'test_helper'

class MiniSlideTest < ActiveSupport::TestCase
  context 'MiniSlide' do
    should belong_to(:mini_slideshow)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)
  end
end
