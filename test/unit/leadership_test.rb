require 'test_helper'

class LeadershipTest < ActiveSupport::TestCase
  context "Leadership" do
    should_belong_to(:leader)
    should_belong_to(:leadership_group)

    should_validate_presence_of(:leader)
    should_validate_presence_of(:leadership_group)
  end
end
