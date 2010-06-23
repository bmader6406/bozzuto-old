require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  context 'NewsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      setup do
        5.times do
          NewsPost.make :section => @section
        end
        NewsPost.make(:unpublished, :section => @section)
        @news = @section.section_news

        get :index, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:news_posts) { @news.published }
    end

    context 'a GET to #show' do
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
