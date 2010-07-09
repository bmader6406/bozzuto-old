require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context 'Video' do
    should_belong_to :property
    should_belong_to :apartment_community
    should_belong_to :home_community

    should_validate_presence_of :url

    should_have_attached_file :image
  end
end
