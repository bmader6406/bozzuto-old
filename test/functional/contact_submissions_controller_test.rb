require 'test_helper'

class ContactSubmissionsControllerTest < ActionController::TestCase
  context 'ContactSubmissionsController' do
    setup do
      @section = Section.make(:about)
    end

    context 'a GET to #show' do
      all_devices do
        context 'with no topic param' do
          setup do
            get :show, :section => @section.to_param
          end

          should respond_with(:success)
          should render_template(:show)
          should assign_to(:section) { @section }
        end
      end

      context 'for KML format' do
        setup do
          get :show,
              :section => @section.to_param,
              :format  => :kml
        end

        should respond_with(:success)
        should render_template(:show)

        should 'render the KML XML' do
          @response.body.should =~ %r{<name>Bozzuto Corporate Office</name>}
          @response.body.should =~ %r{<description>6406 Ivy Lane, Suite 700, Greenbelt, MD 20770</description>}
          @response.body.should =~ %r{<coordinates>39.0089301,-76.8952471,0</coordinates>}
        end
      end
    end

    context 'a GET to #thank_you' do
      all_devices do
        setup do
          get :thank_you, :section => @section.to_param
        end

        should respond_with(:success)
        should render_template(:thank_you)
        should assign_to(:section) { @section }
      end
    end
  end
end
