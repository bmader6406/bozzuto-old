require 'test_helper'

class InfoMessagesControllerTest < ActionController::TestCase
  context "the InfoMessages controller" do
    context "on POST to create" do
      context "for a HomeCommunity" do
        setup do
          @community = HomeCommunity.make
          @community.stubs(:send_info_message_to)
          HomeCommunity.stubs(:find).returns(@community)
          post :create, :home_community_id => @community.id, :phone_number => '1234567890'
        end

        should_redirect_to('home url') {home_community_url(@community)}

        should "send sms message" do
          assert_received(@community, :send_info_message_to) {|e| e.with('1234567890')}
        end
      end

      context "for an ApartmentCommunity" do
        setup do
          @community = ApartmentCommunity.make
          @community.stubs(:send_info_message_to)
          ApartmentCommunity.stubs(:find).returns(@community)
          post :create, :apartment_community_id => @community.id, :phone_number => '1234567890'
        end

        should_redirect_to('apartment url') {apartment_community_url(@community)}

        should "send sms message" do
          assert_received(@community, :send_info_message_to) {|e| e.with('1234567890')}
        end
      end

      context "without a phone number" do
        should "not try to send a text message" do
          @community = stub
          @community.expects(:send_info_message_to).never
          HomeCommunity.stubs(:find).returns(@community)
          post :create, :home_community_id => 1
        end
      end
    end
  end
end
