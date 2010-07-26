require 'test_helper'

class MiniSlideTest < ActiveSupport::TestCase
  context 'MiniSlide' do
    should_belong_to :mini_slideshow

    should_have_attached_file :image

    should_validate_attachment_presence :image
  end
end
