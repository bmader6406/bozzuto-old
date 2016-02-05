require 'test_helper'

class ApartmentFloorPlanGroupsHelperTest < ActionView::TestCase
  include ApartmentFloorPlansHelper

  context "ApartmentFloorPlanGroupsHelper" do
    before { create_floor_plan_groups }

    describe "#render_floor_plan_group_mobile_listings" do
      before do
        @community = ApartmentCommunity.make
        @plan      = ApartmentFloorPlan.make(:apartment_community => @community)
        @group     = @plan.floor_plan_group
      end

      it "renders the partial with the correct options" do
        html = render_floor_plan_group_mobile_listings(@community)
        path = apartment_community_floor_plan_group_layouts_path(@community, @group)

        html.should include(path)
      end
    end

    describe "#floor_plan_group_link" do
      before do
        @community = ApartmentCommunity.make(:availability_url => 'http://viget.com/')
      end

      context "when group is a penthouse" do
        before do
          @group = ApartmentFloorPlanGroup.penthouse
        end

        it "returns the base availability url" do
          html = Nokogiri::HTML(floor_plan_group_link(@community, @group, 2))

          html.at('a').attributes['href'].try(:value).should == @community.availability_url
        end
      end

      context "when group is not a penthouse" do
        before do
          @group = ApartmentFloorPlanGroup.one_bedroom
          @beds = 2
        end

        it "returns the availability url with beds param" do
          html = Nokogiri::HTML(floor_plan_group_link(@community, @group, @beds))

          html.at('a').attributes['href'].try(:value).should == "#{@community.availability_url}?beds=#{@beds}"
        end
      end
    end
  end
end
