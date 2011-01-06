require 'test_helper'

class MiniSlideshowTest < ActiveSupport::TestCase
  context 'MiniSlideshow' do
    should_validate_presence_of :title, :link_url

    context '#typus_name' do
      setup do
        @slideshow = MiniSlideshow.new :title => 'Hey ya'
      end

      should 'return the title' do
        assert_equal 'Hey ya', @slideshow.typus_name
      end
    end
  end
end
