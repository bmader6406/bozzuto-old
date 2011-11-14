require 'test_helper'

class NewsPostsControllerTest < ActionController::TestCase
  context 'NewsPostsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      browser_context do
        setup do
          5.times do
            NewsPost.make :sections => [@section]
          end
          NewsPost.make(:unpublished, :sections => [@section])
          @news = @section.news_posts
        end

        context 'requesting HTML' do
          setup do
            get :index, :section => @section.to_param
          end

          should_respond_with :success
          should_render_template :index
          should_assign_to(:news_posts) { @news.published }
        end

        context 'requesting RSS' do
          setup do
            get :index, :section => @section.to_param, :format => 'rss'
          end

          should_respond_with :success
          should_render_template :index
          should_render_without_layout
          should_respond_with_content_type :rss
          should_assign_to(:news_posts) { @news.published }
        end
      end

      mobile_context do
        setup do
          set_mobile_user_agent!
          get :index, :section => @section.to_param
        end

        should_redirect_to_home_page
      end
    end

    context 'a GET to #show' do
      browser_context do
        setup do
          @news_post = NewsPost.make :sections => [@section]

          get :show, :section => @section.to_param, :news_post_id => @news_post.id
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:news_post) { @news_post }
      end

      mobile_context do
        setup do
          set_mobile_user_agent!

          @news_post = NewsPost.make :sections => [@section]

          get :show, :section => @section.to_param, :news_post_id => @news_post.id
        end

        should_redirect_to_home_page
      end
    end
  end
end
