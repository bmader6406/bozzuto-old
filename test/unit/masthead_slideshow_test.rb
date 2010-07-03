require 'test_helper'

class MastheadSlideshowTest < ActiveSupport::TestCase
  context 'MastheadSlideshow' do
    should_belong_to :page

    should_validate_presence_of :name
  end
end
