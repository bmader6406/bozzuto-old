require 'test_helper'

class GreenHomesControllerTest < ActionController::TestCase
  context "GreenHomesController" do
    before do
      @section = Section.make(:new_homes)
      @page = Page.make(:title => 'Green Homes', :section => @section)
    end

    describe "GET to #index" do
      context "as a normal user" do
        before do
          get :index, :section => @section.to_param
        end

        should_respond_with(:success)
        should_render_template(:index)

        should_assign_to(:section) { @section }
        should_assign_to(:page) { @page }
      end

      context "as an admin" do
        before do
          @user = TypusUser.make
          login_typus_user(@user)

          @page.published = false

          get :index, :section => @section.to_param
        end

        should_respond_with(:success)
        should_render_template(:index)

        should_assign_to(:section) { @section }
        should_assign_to(:page) { @page }
      end
    end

    describe "GET to #show" do
      before do
        @community     = HomeCommunity.make
        @green_package = GreenPackage.make :home_community => @community

        get :show, :id => @community.to_param, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :show

      should_assign_to(:section)       { @section }
      should_assign_to(:page)          { @page }
      should_assign_to(:community)     { @community }
      should_assign_to(:green_package) { @green_package }
    end
  end
end
