require 'test_helper'

class CommunityMediaControllerTest < ActionController::TestCase
  context 'CommunityMediaController' do
    context 'a GET to #index' do
      setup do
        @community = ApartmentCommunity.make
        get :index, :apartment_community_id => @community.id
      end

      should_respond_with :success
      should_render_template :index
      should_render_with_layout :community
      should_assign_to(:community) { @community }
    end
    
    context 'a GET to #index for mobile' do
      setup do
        @community = ApartmentCommunity.make
        @set = PhotoSet.make_unsaved(:property => @community)
        @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
        @set.save

        @photo = Photo.make :photo_set => @set
        @photo_group = PhotoGroup.make(:flickr_raw_title => 'mobile')
        @photo_group.photos << @photo
        
        get :index, :apartment_community_id => @community.id, :format => 'mobile'
      end

      should_respond_with :success
      should_render_template :index
      should_render_with_layout :application
      should_assign_to(:community) { @community }
    end
  end
end
