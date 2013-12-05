require 'test_helper'

class HomeFloorPlansControllerTest < ActionController::TestCase
  context 'HomeFloorPlansController' do
    setup do
      @community = HomeCommunity.make
      @home      = Home.make :home_community => @community
      @plan      = HomeFloorPlan.new(
        :name            => 'Floor plan',
        :home            => @home,
        :image_file_name => 'yay.png'
      )
      @plan.save(false)
    end

    context 'a GET to #index' do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do 
          setup do
            get :index,
              :home_community_id => @community.id,
              :home_id           => @home.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :index,
              :home_community_id => @community.id,
              :home_id           => @home.id
          end

          should_redirect_to('the floor plan groups page') do
            home_community_homes_path(@community)
          end
        end

        mobile_device do
          setup do
            get :index,
              :home_community_id => @community.id,
              :home_id           => @home.id
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:home) { @home }
          should_assign_to(:plans) { [@plan] }
        end
      end
    end

    context 'a GET to #show' do
      context 'with a community that is not published' do
        setup { @community.update_attribute(:published, false) }

        all_devices do
          setup do
            get :show,
              :home_community_id  => @community.id,
              :home_id            => @home.id,
              :id                 => @plan.id
          end

          should_respond_with :not_found
        end
      end

      context 'with a community that is published' do
        desktop_device do
          setup do
            get :show,
              :home_community_id  => @community.id,
              :home_id            => @home.id,
              :id                 => @plan.id
          end

          should_redirect_to('the floor plan groups page') do
            home_community_homes_path(@community)
          end
        end

        mobile_device do
          setup do
            get :show,
              :home_community_id  => @community.id,
              :home_id            => @home.id,
              :id                 => @plan.id
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:home) { @home }
          should_assign_to(:plan) { @plan }
        end
      end
    end
  end
end
