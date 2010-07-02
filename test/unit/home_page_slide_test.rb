require 'test_helper'

class HomePageSlideTest < ActiveSupport::TestCase
  context 'HomePageSlide' do
    should_belong_to :home_page

    should_have_attached_file :image

    should_validate_attachment_presence :image
  end
end
