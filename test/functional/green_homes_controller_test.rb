require 'test_helper'

class GreenHomesControllerTest < ActionController::TestCase
  context 'GreenHomesController' do
    setup do
      @section = Section.make(:new_homes)
      @page = Page.make(:title => 'Green Homes', :section => @section)
    end

    context 'GET to #index' do
      setup do
        get :index, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:section) { @section }
      should_assign_to(:page) { @page }
    end

    context 'GET to #show' do
      setup do
        @community = HomeCommunity.make

        get :show, :id => @community.to_param, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:section)   { @section }
      should_assign_to(:page)      { @page }
      should_assign_to(:community) { @community }
    end
  end
end
