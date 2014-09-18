require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  context "HomesController" do
    setup do
      @community = HomeCommunity.make
    end

    context "a GET to #index" do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :index, :home_community_id => @community.id
          end

          should respond_with(:not_found)
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :index, :home_community_id => @community.id
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:index)
          should assign_to(:community) { @community }
        end

        mobile_device do
          setup do
            get :index,
              :home_community_id => @community.id,
              :format => :mobile
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:index)
          should assign_to(:community) { @community }
        end
      end
    end
  end
end
