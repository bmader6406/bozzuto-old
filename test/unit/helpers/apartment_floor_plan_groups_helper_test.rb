require 'test_helper'

class ApartmentFloorPlanGroupsHelperTest < ActionView::TestCase
  include ApartmentFloorPlansHelper

  context "ApartmentFloorPlanGroupsHelper" do
    describe "#render_floor_plan_group_mobile_listings" do
      before do
        @community = ApartmentCommunity.make
        ApartmentFloorPlan.make(:apartment_community => @community)
      end

      it "renders the partial with the correct options" do
        floor_plan_presenter(@community).groups.each do |group|
          expects(:render).with({
            :partial => 'apartment_floor_plan_groups/listing',
            :locals  => {
              :community => @community,
              :group     => group,
            }
          })
        end

        render_floor_plan_group_mobile_listings(@community)
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
          link = HTML::Document.new(floor_plan_group_link(@community, @group, 2))

          assert_select link.root, 'a', :href => @community.availability_url
        end
      end

      context "when group is not a penthouse" do
        before do
          @group = ApartmentFloorPlanGroup.one_bedroom
          @beds = 2
        end

        it "returns the availability url with beds param" do
          link = HTML::Document.new(floor_plan_group_link(@community, @group, @beds))

          assert_select link.root, 'a', :href => "#{@community.availability_url}?beds=#{@beds}"
        end
      end
    end
  end
end
