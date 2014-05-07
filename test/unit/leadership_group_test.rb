require 'test_helper'

class LeadershipGroupTest < ActiveSupport::TestCase
  context 'LeadershipGroup' do
    should_have_many(:leaderships, :dependent => :destroy)
    should_have_many(:leaders, :through => :leaderships)

    should_validate_presence_of(:name)
  end
end
