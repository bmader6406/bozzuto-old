require 'test_helper'

class MetrosControllerTest < ActionController::TestCase
  context "MetrosController" do
    describe "GET to #index" do
      before do
        @metro = Metro.make

        get :index
      end

      should_respond_with(:success)
      should_render_template(:index)
      should_assign_to(:metros) { [@metro] }
    end

    describe "GET to #show" do
      before do
        @metro = Metro.make

        get :show, :id => @metro.to_param
      end

      should_respond_with(:success)
      should_render_template(:show)
      should_assign_to(:metro) { @metro }
    end
  end
end
