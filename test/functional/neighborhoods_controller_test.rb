require 'test_helper'

class NeighborhoodsControllerTest < ActionController::TestCase
  context "NeighborhoodsController" do
    all_devices do
      describe "GET to #show" do
        before do
          @neighborhood = Neighborhood.make
          @area         = @neighborhood.area
          @metro        = @area.metro

          RelatedNeighborhood.make(:neighborhood => @neighborhood)

          get :show, :metro_id => @metro.to_param,
                     :area_id  => @area.to_param,
                     :id       => @neighborhood.to_param
        end

        should_respond_with(:success)
        should_render_template(:show)
        should_assign_to(:metro) { @metro }
        should_assign_to(:area) { @area }
        should_assign_to(:neighborhood) { @neighborhood }
      end
    end
  end
end
