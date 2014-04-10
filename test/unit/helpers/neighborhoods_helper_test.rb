require 'test_helper'

class NeighborhoodsHelperTest < ActionView::TestCase
  context "Neighborhoods Helper" do
    describe "#render_neighborhoods_listing" do
      context "with an apartment community" do
        before do
          @community = ApartmentCommunity.make
        end

        it "sends #render with the correct parameters" do
          expects(:render).with('neighborhoods/community_listing', :community => @community)

          render_neighborhoods_listing(@community)
        end
      end

      context "with a place" do
        before do
          @area = Area.make
        end

        it "sends #render with the correct parameters" do
          expects(:render).with("areas/listing", :metro => @area.metro, :area => @area)

          render_neighborhoods_listing(@area)
        end
      end
    end
  end
end
