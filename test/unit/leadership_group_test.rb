require 'test_helper'

class LeadershipGroupTest < ActiveSupport::TestCase
  context 'LeadershipGroup' do
    should have_many(:leaderships).dependent(:destroy)
    should have_many(:leaders).through(:leaderships)

    should validate_presence_of(:name)
  end
end
