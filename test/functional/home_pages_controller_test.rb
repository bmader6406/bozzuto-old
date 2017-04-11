require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomePagesController' do

    context 'a GET to #index' do
      setup do
        @home_page = HomePage.new
        @home_page.save(:validate => false)

        @about = Section.make(:about)
      end

      desktop_device do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_with_layout(:homepage)
        should render_template(:index)
        should assign_to(:home_page) { @home_page }
        should assign_to(:section) { @about }
      end
    end
  end
end
