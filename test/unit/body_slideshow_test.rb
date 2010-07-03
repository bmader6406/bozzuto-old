require 'test_helper'

class BodySlideshowTest < ActiveSupport::TestCase
  context 'BodySlideshow' do
    should_belong_to :page

    should_validate_presence_of :name
  end
end
