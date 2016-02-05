require 'test_helper'

class NeighborhoodMembershipTest < ActiveSupport::TestCase
  context "A Neighborhood Membership" do
    subject { NeighborhoodMembership.make }

    should belong_to(:neighborhood)
    should belong_to(:apartment_community)

    should validate_presence_of(:neighborhood)
    should validate_presence_of(:apartment_community)
    should validate_uniqueness_of(:apartment_community_id).scoped_to(:neighborhood_id)
    should validate_inclusion_of(:tier).in_range(1..4)
  end
end
