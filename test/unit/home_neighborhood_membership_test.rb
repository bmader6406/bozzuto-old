require 'test_helper'

class HomeNeighborhoodMembershipTest < ActiveSupport::TestCase
  context "A HomeNeighborhood Membership" do
    subject { HomeNeighborhoodMembership.make }

    should belong_to(:home_neighborhood)
    should belong_to(:home_community)

    should validate_presence_of(:home_neighborhood)
    should validate_presence_of(:home_community)
    should validate_uniqueness_of(:home_community_id).scoped_to(:home_neighborhood_id)
  end
end
