require 'test_helper'

class NewsAndPressControllerTest < ActionController::TestCase
  context 'NewsAndPressController' do
    setup do
      @about = Section.make :about
      @news_and_press = Section.make :news_and_press
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          get :index, :section => @about.to_param
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:latest_news)
        should assign_to(:latest_press)
      end
    end

    context 'a GET to #show' do
      all_devices do
        context 'with no pages in the section' do
          setup do
            get :show, :section => @about.to_param, :page => []
          end

          should respond_with(:not_found)
        end

        context 'with a page param' do
          setup do
            3.times { Page.make :section => @news_and_press }
            @page = @news_and_press.pages.last

            get :show,
              :section => @about.to_param,
              :page => @page.path.split('/')
          end

          should respond_with(:success)
          should render_template(:show)
          should assign_to(:section) { @about }
          should assign_to(:news_section) { @news_and_press }
          should assign_to(:page) { @page }
        end
        
        context 'logged in as a typus user' do
          setup do
            @user = TypusUser.make
            login_typus_user @user
          end
          
          context 'with a page param for an unpublished page' do
            setup do
              3.times { Page.make :section => @news_and_press, :published => false }
              @page = @news_and_press.pages.last

              get :show, :section => @about.to_param, :page => @page.path.split('/')
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:section) { @about }
            should assign_to(:news_section) { @news_and_press }
            should assign_to(:page) { @page }
          end
        end
      end
    end
  end
end
