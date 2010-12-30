require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomePagesController' do
    context 'a GET to #index' do
      setup do
        @home_page = HomePage.new
        @home_page.save(false)
      end

      browser_context do
        setup do
          3.times { |i| NewsPost.make :published_at => (Time.now - i.days) }
          @post = NewsPost.published.latest(1).first

          get :index
        end

        should_respond_with :success
        should_render_with_layout :homepage
        should_render_template :index
        should_assign_to(:home_page) { @home_page }
        should_assign_to(:latest_news) { @post }
      end

      mobile_context do
        setup do
          get :index, :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :index
        should_assign_to(:home_page) { @home_page }
      end
    end
  end
end
