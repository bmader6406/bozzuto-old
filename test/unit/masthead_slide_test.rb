require 'test_helper'

class MastheadSlideTest < ActiveSupport::TestCase
  context 'MastheadSlide' do
    should_belong_to :masthead_slideshow
    should_belong_to :featured_property

    should_validate_presence_of :body
  end
end
