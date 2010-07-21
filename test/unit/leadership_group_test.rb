require 'test_helper'

class LeadershipGroupTest < ActiveSupport::TestCase
  context 'LeadershipGroup' do
    should_validate_presence_of :name
  end
end
