require 'test_helper'

class CommunityMediaControllerTest < ActionController::TestCase
  context "CommunityMediaController" do
    describe "GET to #index" do
      context "with a home community" do
        before do
          @community = HomeCommunity.make

          get :index, :home_community_id => @community.id
        end

        should_respond_with(:success)
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

            should_respond_with(:not_found)
          end
        end

        context "with a community that is published" do
          desktop_device do
            before do
              get :index, :apartment_community_id => @community.id
            end

            should_respond_with(:success)
            should_render_template(:index)
            should_render_with_layout(:community)
            should_assign_to(:community) { @community }
          end
        
          mobile_device do
            before do
              @set = PhotoSet.make_unsaved(:property => @community)
              @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
              @set.save

              @photo = Photo.make :photo_set => @set
              @photo_group = PhotoGroup.make(:flickr_raw_title => 'mobile')
              @photo_group.photos << @photo
              
              get :index, :apartment_community_id => @community.id
            end

            should_respond_with(:success)
            should_render_template(:index)
            should_render_with_layout(:application)
            should_assign_to(:community) { @community }
          end
        end
      end
    end
  end
end
