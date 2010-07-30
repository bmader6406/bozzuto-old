require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  context 'Award' do
    should_validate_presence_of :title

    should_have_attached_file :image
  end
end
