require 'test_helper'

class NeighborhoodsControllerTest < ActionController::TestCase
  context "NeighborhoodsController" do
    all_devices do
      describe "GET to #show" do
        before do
          @neighborhood = Neighborhood.make
          @area         = @neighborhood.area
          @metro        = @area.metro
          @nearby1      = Neighborhood.make
          @nearby2      = Neighborhood.make
          @community    = ApartmentCommunity.make
          @membership   = NeighborhoodMembership.make(:neighborhood => @nearby1, :apartment_community => @community)

          RelatedNeighborhood.make(:neighborhood => @neighborhood, :nearby_neighborhood => @nearby1)
          RelatedNeighborhood.make(:neighborhood => @neighborhood, :nearby_neighborhood => @nearby2)

          get :show, :metro_id => @metro.to_param,
                     :area_id  => @area.to_param,
                     :id       => @neighborhood.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:metro) { @metro }
        should assign_to(:area) { @area }
        should assign_to(:neighborhood) { @neighborhood }
        should assign_to(:nearby_neighborhoods) { [@nearby1] }
      end
    end
  end
end
