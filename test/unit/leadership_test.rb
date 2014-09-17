require 'test_helper'

class LeadershipTest < ActiveSupport::TestCase
  context "Leadership" do
    should belong_to(:leader)
    should belong_to(:leadership_group)

    should validate_presence_of(:leader)
    should validate_presence_of(:leadership_group)
  end
end
