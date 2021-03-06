require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  context 'PagesController' do
    setup do
      @section = Section.make
    end

    context '#current_page_path' do
      context 'when the page param is populated' do
        setup do
          get :show, :section => @section.to_param, :page => 'yay/hooray'
        end

        should 'return the path string' do
          assert_equal 'yay/hooray', @controller.send(:current_page_path)
        end
      end
    end

    context 'a GET to #show' do
      context 'with no pages in the section' do
        setup do
          get :show, :section => @section.to_param
        end

        should respond_with(:not_found)
      end

      context 'with no page params' do
        setup do
          @page = Page.make :section => @section
          get :show, :section => @section.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:section) { @section }
        should assign_to(:page) { @section.pages.first }
      end

      context 'with a page param' do
        setup do
          3.times { Page.make :section => @section }
          @page = @section.pages.last

          get :show, :section => @section.to_param, :page => @page.path
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:section) { @section }
        should assign_to(:page) { @page }
      end
      
      context 'logged in as an admin user' do
        setup do
          sign_in AdminUser.make
        end
        
        context 'with a page param for an unpublished page' do
          setup do
            3.times { Page.make :section => @section, :published => false }
            @page = @section.pages.last

            get :show, :section => @section.to_param, :page => @page.path
          end

          should respond_with(:success)
          should render_template(:show)
          should assign_to(:section) { @section }
          should assign_to(:page) { @page }
        end
      end
      
    end
  end
end
