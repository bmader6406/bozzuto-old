require 'test_helper'

class HomeCommunitiesControllerTest < ActionController::TestCase
  context 'HomeCommunitiesControllerTest' do
    setup do
      @section               = Section.make(:title => 'New Homes')
      @community             = HomeCommunity.make
      @unpublished_community = HomeCommunity.make(:published => false, :title => 'Test')
    end

    context "a GET to #show" do
      context 'when not logged in as an admin' do
        context "with a non-canonical URL" do
          setup do
            @old_slug = @community.to_param
            @community.update_attributes(:title => 'Wayne Manor', :slug => nil)
            @canonical_slug = @community.to_param

            assert @old_slug != @canonical_slug

            get :show, :id => @old_slug
          end

          should respond_with(:redirect)
          should redirect_to('the canonical URL') { home_community_path(@canonical_slug) }
        end

        desktop_device do
          setup do
            get :show, :id => @community.to_param
          end

          should assign_to(:community) { @community }
          should render_with_layout(:community)
          should respond_with(:success)
          should render_template(:show)
        end

        mobile_device do
          setup do
            get :show, :id => @community.to_param
          end

          should assign_to(:community) { @community }
          should render_with_layout(:application)
          should respond_with(:success)
          should render_template(:show)
        end
      end
    end

    context "when logged in as an admin" do
      before do
        sign_in AdminUser.make
      end

      context "a GET to #show for an upublished community" do
        before do
          get :show, id: @unpublished_community.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:community) { @unpublished_community }
      end
    end
  end
end
