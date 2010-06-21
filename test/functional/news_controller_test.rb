require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  context 'NewsController' do
    context 'in the about section' do
      setup do
        @section = Section.make :title => 'About'
      end

      context 'a GET to #index' do
        setup do
          5.times do
            NewsPost.make :section => Section.make
          end
          @news_posts = NewsPost.published.all

          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_render_template :index
        should_assign_to(:news_posts) { @news_posts }
      end

      context 'a GET to #show' do
        setup do
          @news_post = NewsPost.make :section => Section.make

          get :show, :section => @section.to_param, :news_post_id => @news_post.id
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:news_post) { @news_post }
      end
    end


    context 'in a service section' do
      setup do
        @section = Section.make
      end

      context 'a GET to #index' do
        setup do
          5.times do
            NewsPost.make :section => @section
          end
          @news_posts = @section.news_posts

          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_render_template :index
        should_assign_to(:news_posts) { @news_posts }
      end

      context 'a GET to #show' do
        context 'with a news post in another section' do
          setup do
            @news_post = NewsPost.make :section => Section.make

            get :show, :section => @section.to_param, :news_post_id => @news_post.id
          end

          should_respond_with :not_found
        end

        context 'with a news post in this section' do
          setup do
            @news_post = NewsPost.make :section => @section

            get :show, :section => @section.to_param, :news_post_id => @news_post.id
          end

          should_respond_with :success
          should_render_template :show
          should_assign_to(:news_post) { @news_post }
        end
      end
    end
  end
end
