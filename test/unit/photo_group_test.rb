require 'test_helper'

class PhotoGroupTest < ActiveSupport::TestCase
  context 'PhotoGroup' do
    should_have_and_belong_to_many :photos

    should_validate_presence_of :title, :flickr_raw_title
  end
end
