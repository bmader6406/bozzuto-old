require 'test_helper'

class CommunityMediaControllerTest < ActionController::TestCase
  context 'CommunityMediaController' do
    context 'GET to #index' do
      setup { @community = ApartmentCommunity.make }

      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :index, :apartment_community_id => @community.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :index, :apartment_community_id => @community.id
          end

          should_respond_with :success
          should_render_template :index
          should_render_with_layout :community
          should_assign_to(:community) { @community }
        end
      
        mobile_device do
          setup do
            @set = PhotoSet.make_unsaved(:property => @community)
            @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
            @set.save

            @photo = Photo.make :photo_set => @set
            @photo_group = PhotoGroup.make(:flickr_raw_title => 'mobile')
            @photo_group.photos << @photo
            
            get :index, :apartment_community_id => @community.id
          end

          should_respond_with :success
          should_render_template :index
          should_render_with_layout :application
          should_assign_to(:community) { @community }
        end
      end
    end
  end
end
