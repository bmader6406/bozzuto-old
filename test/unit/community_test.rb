require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context "A community" do
    should_belong_to :city
    should_have_many :photos
    should_have_many :floor_plan_groups
    should_have_many :floor_plans, :through => :floor_plan_groups

    should_validate_presence_of :title, :subtitle, :city

    context "#address" do
      setup do
        @address = '202 Rigsbee Ave'
        @community = Community.make(:street_address => @address)
      end

      should "return the formatted address" do
        assert_equal "#{@address}, #{@community.city}", @community.address
      end
    end
  end
end
