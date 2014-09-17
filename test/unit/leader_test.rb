require 'test_helper'

class LeaderTest < ActiveSupport::TestCase
  context "Leader" do
    should have_many(:leaderships).dependent(:destroy)

    should validate_presence_of(:name)
    should validate_presence_of(:title)
    should validate_presence_of(:company)
    should validate_presence_of(:bio)
  end
end
