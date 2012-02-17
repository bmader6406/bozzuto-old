require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomePagesController' do
    context 'a GET to #index' do
      setup do
        @home_page = HomePage.new
        @home_page.save(false)

        @about = Section.make(:about)

        3.times { |i| NewsPost.make :published_at => (Time.now - i.days) }
        @post = NewsPost.published.latest(1).first

        @award = Award.make :sections => [@about]
      end

      browser_context do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_with_layout :homepage
        should_render_template :index
        should_assign_to(:home_page) { @home_page }
        should_assign_to(:section) { @about }
        should_assign_to(:latest_news) { @post }
        should_assign_to(:latest_award) { @award }
      end
      
      context 'in a browser with full_site set to "0"' do
        setup do
          get :index, :full_site => "0"
        end
        
        should_respond_with :success
        should_render_with_layout :application
        should_render_template :index
        should_set_session(:force_full_site){ "0" }
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
      
      context 'on a mobile device with full_site set to "1"' do
        setup do
          3.times { |i| NewsPost.make :published_at => (Time.now - i.days) }
          @post = NewsPost.published.latest(1).first
          
          set_mobile_user_agent!
          get :index, :full_site => "1"
        end
        
        should_respond_with :success
        should_render_with_layout :homepage
        should_render_template :index
        should_assign_to(:home_page) { @home_page }
        should_assign_to(:latest_news) { @post }
        should_set_session(:force_full_site){ "1" }
      end
    end
  end
end
