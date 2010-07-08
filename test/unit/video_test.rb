require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  context 'Video' do
    should_belong_to :community

    should_validate_presence_of :url

    should_have_attached_file :image
  end
end
