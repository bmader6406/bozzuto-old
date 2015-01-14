require 'test_helper'

class AreasControllerTest < ActionController::TestCase
  context "AreasController" do
    all_devices do
      describe "GET to #show" do
        %w(neighborhoods communities).each do |type|
          context "with an area that shows #{type}" do
            before do
              @area1 = Area.make(type.to_sym)
              @area2 = Area.make(:communities)
              @area3 = Area.make(:communities)
              @metro = @area1.metro

              RelatedArea.make(:area => @area1, :nearby_area => @area2)
              RelatedArea.make(:area => @area1, :nearby_area => @area3)

              @neighborhood1 = Neighborhood.make(:area => @area1)
              @neighborhood2 = Neighborhood.make(:area => @area1)
              @community1    = ApartmentCommunity.make
              @community2    = ApartmentCommunity.make
              @membership1   = NeighborhoodMembership.make(:neighborhood => @neighborhood1, :apartment_community => @community1)
              @membership2   = AreaMembership.make(:area => @area2, :apartment_community => @community2)

              get :show, :metro_id => @metro.to_param, :id => @area1.to_param
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:metro) { @metro }
            should assign_to(:area) { @area1 }
            should assign_to(:nearby_areas) { [@area2] }

            if type == 'neighborhoods'
              should assign_to(:neighborhoods) { [@neighborhood1] }
            end
          end
        end
      end
    end
  end
end
