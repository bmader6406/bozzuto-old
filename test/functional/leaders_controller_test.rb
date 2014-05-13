require 'test_helper'

class LeadersControllerTest < ActionController::TestCase
  context "LeadersController" do
    before do
      @section = Section.make(:about)
    end

    describe "GET #index" do
      context "with a leadership page" do
        all_devices do
          before do
            @leadership_page = Page.make(:title => 'leadership', :section => @section)

            get :index, :section => @section.to_param
          end

          should_assign_to(:section) { @section }
          should_assign_to(:page)    { @leadership_page }

          should_respond_with :success
          should_render_template :index
        end
      end

      context "without a leadership page" do
        all_devices do
          before do
            get :index, :section => @section.to_param
          end

          should_not_assign_to(:page)

          should_assign_to(:section) { @section }

          should_respond_with :success
          should_render_template :index
        end
      end
    end

    describe "GET #show" do
      before do
        @leader = Leader.make
      end

      all_devices do
        before do
          get :show, :section => @section.to_param, :id => @leader.to_param
        end

        should_assign_to(:leader)  { @leader }
        should_assign_to(:section) { @section }

        should_respond_with :success
        should_render_template :show
      end
    end
  end
end
