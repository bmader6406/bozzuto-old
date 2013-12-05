require 'test_helper'

class RankingsControllerTest < ActionController::TestCase
  context 'RankingsController' do
    setup do
      @section = Section.make(:about)
      @page    = Page.make :title => 'Rankings', :section => @section
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end
    end
  end
end
