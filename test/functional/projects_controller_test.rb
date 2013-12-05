require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context 'ProjectsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      desktop_device do
        setup do
          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_assign_to(:section) { @section }
        should_assign_to(:categories) { ProjectCategory.all }
      end

      mobile_device do
        setup do
          get :index, :section => @section.to_param
        end

        should_respond_with :success
        should_assign_to(:section) { @section }
      end
    end

    context 'a GET to #show' do
      setup do
        @project = Project.make :section => @section
      end

      all_devices do
        setup do
          get :show, :section => @section.to_param, :project_id => @project.to_param
        end

        should_respond_with :success
        should_assign_to(:section) { @section }
        should_assign_to(:project) { @project }
      end
    end
  end
end
