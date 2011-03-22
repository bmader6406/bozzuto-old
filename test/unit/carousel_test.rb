require 'test_helper'

class CarouselTest < ActiveSupport::TestCase
  context 'A carousel' do
    should_validate_presence_of :name

    should_belong_to :page
  end
end
