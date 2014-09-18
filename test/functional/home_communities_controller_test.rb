require 'test_helper'

class HomeCommunitiesControllerTest < ActionController::TestCase
  context 'HomeCommunitiesControllerTest' do
    setup do
      @section = Section.make :title => 'New Homes'
      @community = HomeCommunity.make
      @unpublished_community = HomeCommunity.make(:published => false)
    end

    context 'a GET to #index' do
      setup do
        5.times { HomeCommunity.make }
        @communities = HomeCommunity.published.ordered_by_title.all(:limit => 6)

        get :index
      end

      should respond_with(:success)
      should render_template(:index)
      should assign_to(:section) { @section }
      should assign_to(:communities) { @communities }
    end

    context 'a GET to #map' do
      setup do
        5.times { HomeCommunity.make }
        @communities = HomeCommunity.published.ordered_by_title.all
        get :map
      end

      should respond_with(:success)
      should render_template(:map)
      should assign_to(:section) { @section }
      should assign_to(:communities) { @communities }
    end

    context "a GET to #show" do
      context 'when not logged in to typus' do
        context "with a non-canonical URL" do
          setup do
            @old_slug = @community.to_param
            @community.update_attribute(:title, 'Wayne Manor')
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
    
    context 'logged in to typus' do
      setup do
        @user = TypusUser.make
        login_typus_user @user
      end
      
      context "a GET to #show for an upublished community" do
        setup do
          get :show, :id => @unpublished_community.to_param
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:community) { @unpublished_community }
      end
    end
  end
end
