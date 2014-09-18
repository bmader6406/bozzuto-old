require 'test_helper'

class CommunityMediaControllerTest < ActionController::TestCase
  context "CommunityMediaController" do
    describe "GET to #index" do
      context "with a home community" do
        before do
          @community = HomeCommunity.make

          get :index, :home_community_id => @community.id
        end

        should respond_with(:success)
      end

      context "with an apartment community" do
        before do
          @community = ApartmentCommunity.make
        end

        context "with a community that is not published" do
          before do
            @community.update_attribute(:published, false)
          end

          all_devices do
            before do
              get :index, :apartment_community_id => @community.id
            end

            should respond_with(:not_found)
          end
        end

        context "with a community that is published" do
          desktop_device do
            before do
              get :index, :apartment_community_id => @community.id
            end

            should respond_with(:success)
            should render_template(:index)
            should render_with_layout(:community)
            should assign_to(:community) { @community }
          end
        
          mobile_device do
            before do
              get :index, :apartment_community_id => @community.id
            end

            should respond_with(:success)
            should render_template(:index)
            should render_with_layout(:application)
            should assign_to(:community) { @community }
          end
        end
      end
    end
  end
end
