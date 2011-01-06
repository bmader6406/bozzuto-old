require 'test_helper'

class LassoSubmissionsControllerTest < ActionController::TestCase
  context 'LassoSubmissionsController' do
    setup do
      @community = HomeCommunity.make({
        :lasso_uid => 'auid',
        :lasso_client_id => 'my_client_id',
        :lasso_project_id => 'my_project_id'
      })
      @page = PropertyContactPage.make(:property => @community)
    end

    context 'a GET to #show' do
      setup do
        get :show, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to :community
    end
    
    context 'a GET to #show without page' do
      setup do
        @page.destroy
        get :show, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to :community
    end

    context 'a GET to #thank_you' do
      context 'with an email in the lasso cookie' do
        setup do
          @email = Faker::Internet.email
          @request.cookies['lasso_email'] = @email

          get :thank_you, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_template :thank_you
        should_assign_to :community
        should_assign_to(:email) { @email }

        should 'erase the lasso cookie' do
          assert_nil cookies['lasso_email']
        end
      end

      context 'without an email in the lasso cookie' do
        setup do
          get :thank_you, :home_community_id => @community.to_param
        end

        should_respond_with :success
        should_render_template :thank_you
        should_assign_to :community
        should_not_assign_to(:email)
      end
    end
  end
end
