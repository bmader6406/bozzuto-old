require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  context 'Award' do
    should_validate_presence_of :title

    should_belong_to :section
  end
end
