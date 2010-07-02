require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomeController' do
    context 'a GET to #index' do
      setup do
        3.times { |i| NewsPost.make :published_at => (Time.now - i.days) }
        @post = NewsPost.published.latest(1).first

        @property = ApartmentCommunity.make
        @home_page = HomePage.new(:featured_property => @property)
        @home_page.save(false)

        get :index
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:home_page) { @home_page }
      should_assign_to(:latest_news) { @post }
      should_assign_to(:featured_property) { @property }
    end
  end
end
