require 'test_helper'

class CarouselTest < ActiveSupport::TestCase
  context 'A carousel' do
    should validate_presence_of(:name)

    should belong_to(:content)

    should accept_nested_attributes_for(:panels)
  end
end
