require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  context 'CountiesController' do
    before do
      @state  = State.make
      @county = County.make :state => @state
      @city   = City.make :state => @state

      @county.cities << @city

      @community = ApartmentCommunity.make(
        :city   => @city,
        :county => @county
      )
    end

    describe "GET to #index" do
      desktop_device do
        before do
          get :index, :state_id => @state.to_param
        end

        should respond_with(:redirect)
        should redirect_to('the metros page') { metros_url }
      end

      mobile_device do
        before do
          get :index, :state_id => @state.to_param
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:state) { @state }
        should assign_to(:counties) { @state.counties.ordered_by_name }
      end
    end

    describe "GET to #show" do
      desktop_device do
        before do
          get :show, :id => @county.to_param
        end

        should respond_with(:redirect)
        should redirect_to('the metros page') { metros_url }
      end

      mobile_device do
        before do
          get :show, :id => @county.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:county) { @county }
        should assign_to(:apartment_communities) {
          @county.apartment_communities.published.ordered_by_title
        }
      end
    end
  end
end
