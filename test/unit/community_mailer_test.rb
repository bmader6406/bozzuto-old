require 'test_helper'

class CommunityMailerTest < ActionMailer::TestCase
  context "CommunityMailer" do
    setup do
      @community = ApartmentCommunity.make
    end

    context "#send_to_friend" do
      setup do
        @to = Faker::Internet.email

        assert_difference('ActionMailer::Base.deliveries.count', 1) do
          @email = CommunityMailer.deliver_send_to_friend(@to, @community)
        end
      end

      should "deliver the message" do
        assert_equal [@to], @email.to
      end

      should "have the community title as subject" do
        assert_equal @community.title, @email.subject
      end

      should "have a link to the community in the body" do
        assert_match /\/communities\/#{@community.to_param}/,
          @email.body
      end
    end
  end
end
