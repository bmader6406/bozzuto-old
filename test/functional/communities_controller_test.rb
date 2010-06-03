require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase
  context "CommunitiesController" do
    setup do
      @community = Community.make
    end

    %w(show features media neighborhood promotions contact).each do |action|
      context "a GET to ##{action}" do
        setup do
          get action, :id => @community.id
        end

        should_assign_to(:community) { @community }
        should_respond_with :success
        should_render_template action
      end
    end


    context "a POST to #send_to_friend" do
      context "with a missing email address" do
        setup do
          assert_no_difference("ActionMailer::Base.deliveries.count") do
            post :send_to_friend, { :id => @community.id }
          end
        end

        should_set_the_flash_to /must submit a valid email address/i
        should_redirect_to("#show") { community_path(@community) }
      end

      context "with an email address" do
        setup do
          @to = Faker::Internet.email

          assert_difference("ActionMailer::Base.deliveries.count", 1) do
            post :send_to_friend, {
              :id    => @community.id,
              :email => @to
            }
          end

          @email = ActionMailer::Base.deliveries.last
        end

        should_redirect_to("#show") { community_path(@community) }

        should "send the email" do
          assert_equal [@to], @email.to
        end
      end
    end
  end
end
