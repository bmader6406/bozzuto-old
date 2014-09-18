require 'test_helper'

class NewsPostsControllerTest < ActionController::TestCase
  context 'NewsPostsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      setup do
        5.times do
          NewsPost.make :sections => [@section]
        end
        NewsPost.make(:unpublished, :sections => [@section])
        @news = @section.news_posts
      end

      all_devices do
        context 'requesting HTML' do
          setup do
            get :index, :section => @section.to_param
          end

          should respond_with(:success)
          should render_template(:index)
          should assign_to(:news_posts) { @news.published }
        end
      end

      context 'requesting RSS' do
        setup do
          get :index, :section => @section.to_param, :format => 'rss'
        end

        should respond_with(:success)
        should render_template(:index)
        should respond_with_content_type(:rss)
        should assign_to(:news_posts) { @news.published }
      end
    end

    context 'a GET to #show' do
      all_devices do
        setup do
          @news_post = NewsPost.make :sections => [@section]

          get :show, :section => @section.to_param, :id => @news_post.id
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:news_post) { @news_post }
      end
    end
  end
end
