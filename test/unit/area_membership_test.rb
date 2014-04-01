require 'test_helper'

class AreaMembershipTest < ActiveSupport::TestCase
  context "An Area Membership" do
    subject { AreaMembership.make }

    should_belong_to(:area)
    should_belong_to(:apartment_community)

    should_validate_presence_of(:area)
    should_validate_presence_of(:apartment_community)
    should_validate_uniqueness_of(:apartment_community_id, :scoped_to => :area_id)
  end
end
