require 'test_helper'

class CareersControllerTest < ActionController::TestCase
  context 'GET to :index' do
    browser_context do
      setup do
        @section = Section.make :title => 'Careers'

        get :index, :section => 'careers'
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:section) { @section }
    end

    mobile_context do
      setup do
        @section = Section.make :title => 'Careers'
        @page    = Page.make :section => @section

        set_mobile_user_agent!
        get :index, :section => 'careers',
                    :format  => :mobile
      end

      should_respond_with :success
      should_render_template 'pages/show.mobile.erb'
      should_assign_to(:section) { @section }
      should_assign_to(:page)    { @page }
    end
  end
end
