require 'test_helper'

class LassoSubmissionsControllerTest < ActionController::TestCase
  context 'LassoSubmissionsController' do
    setup do
      @community = HomeCommunity.make
      @community.create_lasso_account({
        :uid              => 'auid',
        :client_id  => 'my_client_id',
        :project_id => 'my_project_id'
      })
      @page = PropertyContactPage.make(:property => @community)
    end


    context 'a GET to #show' do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        desktop_device do
          context 'with a page' do
            setup do
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :not_found
          end

          context 'without page' do
            setup do
              @page.destroy
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :not_found
          end
        end

        mobile_device do
          context 'with a page' do
            setup do
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :not_found
          end

          context 'without page' do
            setup do
              @page.destroy

              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :not_found
          end
        end
      end

      context 'with a community that is published' do
        desktop_device do
          context 'with a page' do
            setup do
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :community
          end

          context 'without page' do
            setup do
              @page.destroy
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :community
          end
        end

        mobile_device do
          context 'with a page' do
            setup do
              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :community
          end

          context 'without page' do
            setup do
              @page.destroy

              get :show, :home_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :community
          end
        end
      end
    end
    

    context 'a GET to #thank_you' do
      desktop_device do
        context 'with an email in the lasso cookie' do
          setup do
            @email = Faker::Internet.email
            @request.cookies['lasso_email'] = @email

            get :thank_you, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :thank_you
          should_assign_to :community
          should_assign_to(:email) { @email }

          should 'erase the lasso cookie' do
            assert_nil cookies['lasso_email']
          end
        end
      end

      mobile_device do
        context 'with an email in the lasso cookie' do
          setup do
            @email = Faker::Internet.email
            @request.cookies['lasso_email'] = @email

            get :thank_you, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :thank_you
          should_assign_to :community
          should_assign_to(:email) { @email }

          should 'erase the lasso cookie' do
            assert_nil cookies['lasso_email']
          end
        end
      end

      desktop_device do
        context 'without an email in the lasso cookie' do
          setup do
            get :thank_you, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :thank_you
          should_assign_to :community
          should_not_assign_to(:email)
        end
      end

      mobile_device do
        context 'without an email in the lasso cookie' do
          setup do
            get :thank_you, :home_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :thank_you
          should_assign_to :community
          should_not_assign_to(:email)
        end
      end
    end
  end
end
