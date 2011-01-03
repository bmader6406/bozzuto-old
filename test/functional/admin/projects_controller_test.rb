require 'test_helper'

# ControllerTest generated by Typus, use it to test the extended admin functionality.
class Admin::ProjectsControllerTest < ActionController::TestCase
  context 'Admin::ApartmentCommunitiesController' do
    setup do
      @user = TypusUser.make
      login_typus_user @user
      @project1 = Project.make
      @project2 = Project.make
      @project1.destroy
    end
    
    context 'get #list_deleted' do
      setup do
        get :list_deleted
      end
      
      should_respond_with :success
      should_render_template :list_deleted
      should_assign_to :items
    end
  end
end