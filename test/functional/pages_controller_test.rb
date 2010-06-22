require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  context 'PagesController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #show' do
      context 'for the services page' do
        setup do
          @page = Page.make :title => 'services'

          get :show, :template => 'services'
        end

        should_respond_with :success
        should_render_template :services
        should_assign_to(:page) { @page }
      end

      context 'with no pages in the section' do
        setup do
          get :show, :section => @section.to_param, :page => []
        end

        should_respond_with :not_found
      end

      context 'with no page params' do
        setup do
          @page = Page.make :section => @section
          get :show, :section => @section.to_param, :page => []
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:section) { @section }
        should_assign_to(:page) { @section.pages.first }
      end

      context 'with a page param' do
        setup do
          3.times { Page.make :section => @section }
          @page = @section.pages.last

          get :show, :section => @section.to_param, :page => @page.path
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:section) { @section }
        should_assign_to(:page) { @page }
      end
    end
  end
end
