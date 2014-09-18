require 'test_helper'

class HomePagesControllerTest < ActionController::TestCase
  context 'HomePagesController' do
    context '#latest_award' do
      setup do
        @unpublished = Award.make(:unpublished)
        @published1  = Award.make(:published_at => 3.days.ago)
        @published2  = Award.make(:published_at => 4.days.ago)
      end

      context 'with no featured award' do
        should 'return the two most recent unfeatured published awards' do
          assert_equal [@published1, @published2], @controller.send(:latest_awards)
        end
      end

      context 'with a featured award' do
        setup do
          @featured = Award.make(:published_at => 1.days.ago, :featured => true)
        end

        should 'return the featured and published awards' do
          assert_equal [@featured, @published1], @controller.send(:latest_awards)
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
        @home_page.save(:validate => false)

        @about = Section.make(:about)
      end

      desktop_device do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_with_layout(:homepage)
        should render_template(:index)
        should assign_to(:home_page) { @home_page }
        should assign_to(:section) { @about }
      end
    end
  end
end
