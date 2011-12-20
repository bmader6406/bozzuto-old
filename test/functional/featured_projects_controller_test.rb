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
      browser_context do
        setup { get :index }

        should_respond_with :redirect
        should_redirect_to('the services page') { section_page_path('services') }
      end

      mobile_context do
        setup do
          get :index, :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :index
        should_assign_to(:projects) { [@project1, @project2] }
      end
    end

    context 'GET to #show' do
      browser_context do
        setup { get :show, :id => @project1.cached_slug }

        should_respond_with :redirect
        should_redirect_to('the services page') { section_page_path('services') }
      end

      mobile_context do
        setup do
          get :show,
            :id     => @project1.cached_slug,
            :format => :mobile
        end

        should_respond_with :success
        should_render_with_layout :application
        should_render_template :show
        should_assign_to(:project) { @project1 }
      end
    end
  end
end
