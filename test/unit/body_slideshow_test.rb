require 'test_helper'

class BodySlideshowTest < ActiveSupport::TestCase
  context 'BodySlideshow' do
    should belong_to(:page)
    should have_many(:slides)

    should validate_presence_of(:name)
  end
end
