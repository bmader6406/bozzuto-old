require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    before do
      @community = ApartmentCommunity.make
    end

    describe "GET #show" do
      context "with a non-canonical URL" do
        before do
          @old_slug = @community.to_param
          @community.update_attributes(:title => 'Wayne Manor', :slug => nil)
          @canonical_slug = @community.to_param

          @canonical_slug.should_not == @old_slug

          get :show, :id => @old_slug
        end

        should respond_with(:redirect)
        should redirect_to('the canonical URL') { apartment_community_path(@canonical_slug) }
      end

      context "with an unpublished community" do
        before { @community.update_attribute(:published, false) }

        all_devices do
          before do
            get :show, :id => @community.to_param
          end

          should respond_with(:not_found)
        end

        context "when passed with a preview param" do
          all_devices do
            before do
              get :show, :id => @community.to_param, preview: 'true'
            end

            should respond_with(:success)
            should render_template(:show)
            should assign_to(:community) { @community }
          end
        end
      end

      context "with a published community" do
        desktop_device do
          before do
            get :show, :id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:show)
          should assign_to(:community) { @community }
        end

        mobile_device do
          before do
            get :show, :id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:show)
          should assign_to(:community) { @community }
        end
      end

      context "for KML format" do
        before do
          @community.update_attributes(title: 'Wayne Manor')

          get :show, :id => @community.to_param, :format => :kml
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:community) { @community }

        it  "renders the KML XML" do
          @response.body.should =~ /<name>Wayne Manor<\/name>/
          @response.body.should =~ /<coordinates>#{@community.latitude},#{@community.longitude},0<\/coordinates>/
        end
      end
    end
    
    describe "logged in to the admin" do
      before do
        @unpublished_community = ApartmentCommunity.make(:published => false)
        @user = AdminUser.make
        sign_in @user
      end
      
      context "a GET to #show for an upublished community" do
        before do
          get :show, :id => @unpublished_community.to_param
        end

        should assign_to(:community) { @unpublished_community }
        should respond_with(:success)
        should render_template(:show)
      end
    end
  end
end
