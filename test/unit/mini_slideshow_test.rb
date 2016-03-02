require 'test_helper'

class MiniSlideshowTest < ActiveSupport::TestCase
  context 'MiniSlideshow' do
    should validate_presence_of(:title)
    should validate_presence_of(:link_url)

    context '#to_s' do
      setup do
        @slideshow = MiniSlideshow.new :title => 'Hey ya'
      end

      should 'return the title' do
        assert_equal 'Hey ya', @slideshow.to_s
      end
    end
  end
end
