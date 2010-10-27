require 'test_helper'

class ApartmentCommunitiesControllerTest < ActionController::TestCase
  context "ApartmentCommunitiesController" do
    setup { @community = ApartmentCommunity.make }

    context 'get #index' do
      context 'for the search view' do
        setup do
          get :index
        end

        should_respond_with :success
        should_render_template :index
      end

      context 'for the map view' do
        setup do
          get :index, :template => 'map'
        end

        should_respond_with :success
        should_render_template :index
      end
    end

    context "a GET to #show" do
      setup do
        get :show, :id => @community.to_param
      end

      should_assign_to(:community) { @community }
      should_respond_with :success
      should_render_template :show
    end


    context "a POST to #send_to_friend" do
      context "with a missing email address" do
        setup do
          assert_no_difference("ActionMailer::Base.deliveries.count") do
            post :send_to_friend, { :id => @community.to_param }
          end
        end

        should_set_the_flash_to /must submit a valid email address/i
        should_redirect_to("#show") { apartment_community_path(@community) }
      end

      context "with an email address" do
        setup do
          @to = Faker::Internet.email

          assert_difference("ActionMailer::Base.deliveries.count", 1) do
            post :send_to_friend, {
              :id    => @community.to_param,
              :email => @to
            }
          end

          @email = ActionMailer::Base.deliveries.last
        end

        should_redirect_to("#show") { apartment_community_path(@community) }

        should "send the email" do
          assert_equal [@to], @email.to
        end
      end
    end
  end
end
