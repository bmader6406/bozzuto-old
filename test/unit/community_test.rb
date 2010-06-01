require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context "A community" do
    should_belong_to :city
    should_have_many :photos
    should_have_many :pages
    should_have_many :links
    should_have_many :floor_plan_groups
    should_have_many :floor_plans, :through => :floor_plan_groups

    should_validate_presence_of :title, :subtitle, :city
  end
end
