require 'test_helper'

class NewsAndPressControllerTest < ActionController::TestCase
  context 'NewsAndPressController' do
    setup do
      @about = Section.make :about
      @news_and_press = Section.make :news_and_press
    end

    context 'a GET to #index' do
      setup do
        get :index, :section => @about.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to :latest_news
      should_assign_to :latest_press
    end

    context 'a GET to #show' do
      context 'with no pages in the section' do
        setup do
          get :show, :section => @about.to_param, :page => []
        end

        should_respond_with :not_found
      end

      context 'with a page param' do
        setup do
          3.times { Page.make :section => @news_and_press }
          @page = @news_and_press.pages.last

          get :show,
            :section => @about.to_param,
            :page => @page.path.split('/')
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:section) { @about }
        should_assign_to(:news_section) { @news_and_press }
        should_assign_to(:page) { @page }
      end
    end
  end
end
