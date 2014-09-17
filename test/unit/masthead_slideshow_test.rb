require 'test_helper'

class MastheadSlideshowTest < ActiveSupport::TestCase
  context 'MastheadSlideshow' do
    should belong_to(:page)
    should have_many(:slides)

    should validate_presence_of(:name)
  end
end
