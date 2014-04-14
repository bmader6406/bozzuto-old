require 'test_helper'

class AreasControllerTest < ActionController::TestCase
  context "AreasController" do
    all_devices do
      describe "GET to #show" do
        %w(neighborhoods communities).each do |type|
          context "with an area that shows #{type}" do
            before do
              @area  = Area.make(type.to_sym)
              @metro = @area.metro

              RelatedArea.make(:area => @area)

              get :show, :metro_id => @metro.to_param, :id => @area.to_param
            end

            should_respond_with(:success)
            should_render_template(:show)
            should_assign_to(:metro) { @metro }
            should_assign_to(:area) { @area }
          end
        end
      end
    end
  end
end
