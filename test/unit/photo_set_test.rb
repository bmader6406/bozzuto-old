require 'test_helper'

class PhotoSetTest < ActiveSupport::TestCase
  context 'PhotoSet' do
    should_belong_to :community

    should_validate_presence_of :title, :flickr_set_id
  end
end
