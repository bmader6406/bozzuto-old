require 'test_helper'

class CareersControllerTest < ActionController::TestCase
  context 'GET to :index' do
    setup do
      @section = Section.make :title => 'Careers'

      get :index, :section => 'careers'
    end

    should_respond_with :success
    should_render_template :index
    should_assign_to(:section) { @section }
  end
end
