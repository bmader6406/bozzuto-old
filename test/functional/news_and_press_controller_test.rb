require 'test_helper'

class NewsAndPressControllerTest < ActionController::TestCase
  context 'NewsAndPressController' do
    setup do
      @about = Section.make :about
      @news_and_press = Section.make :news_and_press
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          get :index, :section => @about.to_param
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:latest_news)
        should assign_to(:latest_press)
      end
    end
  end
end
