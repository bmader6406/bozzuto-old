require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context 'Video' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)

    should validate_presence_of(:url)

    should have_attached_file(:image)
  end
end
