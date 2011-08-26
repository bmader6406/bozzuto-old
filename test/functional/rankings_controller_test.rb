require 'test_helper'

class RankingsControllerTest < ActionController::TestCase
  context 'LeadersController' do
    setup do
      @section = Section.make(:about)
      @page    = Page.make :title => 'Rankings', :section => @section
    end

    context 'a GET to #index' do
      %w(browser mobile).each do |device|
        send("#{device}_context") do
          setup do
            set_mobile_user_agent! if device == 'mobile'

            get :index
          end

          should_respond_with :success
          should_render_template :index
        end
      end
    end
  end
end
