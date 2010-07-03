require 'test_helper'

class BodySlideTest < ActiveSupport::TestCase
  context 'BodySlide' do
    should_belong_to :slideshow

    should_have_attached_file :image

    should_validate_attachment_presence :image
  end
end
