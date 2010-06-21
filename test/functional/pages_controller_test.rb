require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  context 'PagesController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #show' do
      context 'with no pages params' do
        setup do
          #get :show, :section => @section.to_param, :pages => []
        end

        #should_respond_with :success
        #should_render_template :show
        #should_assign_to(:section) { @section }
        #should_assign_to(:pages) { [] }
      end
    end
  end
end
