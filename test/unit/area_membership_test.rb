require 'test_helper'

class AreaMembershipTest < ActiveSupport::TestCase
  context "An Area Membership" do
    subject { AreaMembership.make }

    should belong_to(:area)
    should belong_to(:apartment_community)

    should validate_presence_of(:area)
    should validate_presence_of(:apartment_community)
    should validate_uniqueness_of(:apartment_community_id).scoped_to(:area_id)
    should validate_inclusion_of(:tier).in_range(1..4)
  end
end
