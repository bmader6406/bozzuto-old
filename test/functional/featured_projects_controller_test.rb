require 'test_helper'

class FeaturedProjectsControllerTest < ActionController::TestCase
  context 'FeaturedProjectsController' do
    setup do
      @section = Section.make

      @project1 = Project.make({
        :title           => 'Alpha',
        :section         => @section,
        :featured_mobile => true
      })

      @project2 = Project.make({
        :title           => 'Omega',
        :section         => @section,
        :featured_mobile => true
      })
    end

    context 'GET to #index' do
      desktop_device do
        setup { get :index }

        should respond_with(:redirect)
        should redirect_to('the services page') { section_page_path('services') }
      end

      mobile_device do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_with_layout(:application)
        should render_template(:index)
        should assign_to(:projects) { [@project1, @project2] }
      end
    end

    context 'GET to #show' do
      desktop_device do
        setup { get :show, :id => @project1.cached_slug }

        should respond_with(:redirect)
        should redirect_to('the services page') { section_page_path('services') }
      end

      mobile_device do
        setup do
          get :show, :id => @project1.cached_slug
        end

        should respond_with(:success)
        should render_with_layout(:application)
        should render_template(:show)
        should assign_to(:project) { @project1 }
      end
    end
  end
end
