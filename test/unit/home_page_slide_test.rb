require 'test_helper'

class HomePageSlideTest < ActiveSupport::TestCase
  context 'HomePageSlide' do
    should belong_to(:home_page)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)
  end
end
