require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context 'HomeController' do
    context 'a GET to #index' do
      setup do
        3.times { |i| NewsPost.make :published_at => (Time.now - i.days) }
        @post = NewsPost.published.latest(1).first

        get :index
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:latest_news) { @post }
    end
  end
end
