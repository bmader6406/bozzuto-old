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

          should assign_to(:section) { @section }
          should assign_to(:page)    { @leadership_page }

          should respond_with(:success)
          should render_template(:index)
        end
      end

      context "without a leadership page" do
        all_devices do
          before do
            get :index, :section => @section.to_param
          end

          should assign_to(:section) { @section }

          should respond_with(:success)
          should render_template(:index)
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

        should assign_to(:leader)  { @leader }
        should assign_to(:section) { @section }

        should respond_with(:success)
        should render_template(:show)
      end
    end
  end
end
