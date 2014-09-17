require 'test_helper'

class CareersControllerTest < ActionController::TestCase
  context 'CareersController' do
    context 'GET to :index' do
      desktop_device do
        setup do
          @section = Section.make :title => 'Careers'

          get :index, :section => 'careers'
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:section) { @section }
      end

      mobile_device do
        setup do
          @section = Section.make :title => 'Careers'
          @page    = Page.make :section => @section

          get :index, :section => 'careers'
        end

        should respond_with(:success)
        should render_template('pages/show')
        should assign_to(:section) { @section }
        should assign_to(:page)    { @page }
      end
    end
  end
end
