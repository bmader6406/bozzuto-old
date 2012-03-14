require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomePagesController' do
    context '#latest_award' do
      setup do
        @unpublished = Award.make(:unpublished)
        @published   = Award.make(:published_at => 3.days.ago)
      end

      context 'with no featured award' do
        should 'return the published award' do
          assert_equal @published, @controller.send(:latest_award)
        end
      end

      context 'with a featured award' do
        setup { @featured = Award.make(:published_at => 3.days.ago, :featured => true) }

        should 'return the featured and published award' do
          assert_equal @featured, @controller.send(:latest_award)
        end
      end
    end

    context '#latest_news' do
      setup do
        @unpublished = NewsPost.make(:unpublished)
        @published   = NewsPost.make(:published_at => 3.days.ago)
      end

      context 'with no featured post' do
        should 'return the published post' do
          assert_equal @published, @controller.send(:latest_news)
        end
      end

      context 'with a featured award' do
        setup { @featured = NewsPost.make(:published_at => 3.days.ago, :featured => true) }

        should 'return the featured and published award' do
          assert_equal @featured, @controller.send(:latest_news)
        end
      end
    end

    context 'a GET to #index' do
      setup do
        @home_page = HomePage.new
        @home_page.save(false)

        @about = Section.make(:about)
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
          set_mobile_user_agent!
          get :index, :full_site => "1"
        end
        
        should_respond_with :success
        should_render_with_layout :homepage
        should_render_template :index
        should_assign_to(:home_page) { @home_page }
        should_set_session(:force_full_site){ "1" }
      end
    end
  end
end
