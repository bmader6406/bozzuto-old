require 'test_helper'

class SmsMessagesControllerTest < ActionController::TestCase
  context "the SmsMessages controller" do
    context "GET to #new" do
      mobile_device do
        setup do
          @community = HomeCommunity.make
          get :new, :home_community_id => @community.to_param
        end
        
        should_respond_with :success
        should_render_template :new
        should_render_with_layout :application
        should_assign_to(:community) { @community }
      end
    end
    
    context "on POST to create" do
      desktop_device do
        context "for a HomeCommunity" do
          setup do
            @community = HomeCommunity.make
            @community.stubs(:send_info_message_to)
            HomeCommunity.stubs(:find).returns(@community)

            post :create,
              :home_community_id => @community.id,
              :phone_number      => '1234567890'
          end

          should_redirect_to('thank you page') {
            thank_you_home_community_sms_message_path(@community)
          }

          should "send sms message" do
            assert_received(@community, :send_info_message_to) { |e| e.with('1234567890') }
          end
        end

        context "for an ApartmentCommunity" do
          setup do
            @community = ApartmentCommunity.make
            @community.stubs(:send_info_message_to)
            ApartmentCommunity.stubs(:find).returns(@community)

            post :create,
              :apartment_community_id => @community.id,
              :phone_number           => '1234567890'
          end

          should_redirect_to('thank you page') {
            thank_you_apartment_community_sms_message_path(@community)
          }

          should "send sms message" do
            assert_received(@community, :send_info_message_to) {|e| e.with('1234567890')}
          end
        end

        context "without a phone number" do
          setup do
            @community = HomeCommunity.make
            @community.expects(:send_info_message_to).never
            HomeCommunity.stubs(:find).returns(@community)

            post :create,
              :home_community_id => @community.id,
              :phone_number      => ''
          end

          should_redirect_to('main community page') { home_community_path(@community) }

          should 'set an error in the flash' do
            assert flash[:send_to_phone_errors]
          end
        end
      end
      
      mobile_device do
        context "for a HomeCommunity" do
          setup do
            @community = HomeCommunity.make
            @community.stubs(:send_info_message_to)
            HomeCommunity.stubs(:find).returns(@community)

            post :create,
                 :home_community_id => @community.to_param,
                 :phone_number      => '1234567890'
          end

          should_respond_with :success
          should_render_template :thank_you
          should_render_with_layout :application

          should "send sms message" do
            assert_received(@community, :send_info_message_to) { |e| e.with('1234567890') }
          end
        end

        context "for an ApartmentCommunity" do
          setup do
            @community = ApartmentCommunity.make
            @community.stubs(:send_info_message_to)
            ApartmentCommunity.stubs(:find).returns(@community)

            post :create,
                 :apartment_community_id => @community.to_param,
                 :phone_number           => '1234567890'
          end

          should_respond_with :success
          should_render_template :thank_you
          should_render_with_layout :application

          should "send sms message" do
            assert_received(@community, :send_info_message_to) {|e| e.with('1234567890')}
          end
        end

        context "without a phone number" do
          setup do
            @community = HomeCommunity.make
            @community.expects(:send_info_message_to).never
            HomeCommunity.stubs(:find).returns(@community)

            post :create,
                 :home_community_id => @community.to_param,
                 :phone_number      => ''
          end

          should_respond_with :success
          should_render_template :new
          should_render_with_layout :application
        end
      end
    end

    context 'a GET to thank_you' do
      setup do
        @community = HomeCommunity.make

        get :thank_you, :home_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :thank_you
      should_render_with_layout :community
      should_assign_to(:community) { @community }
    end
  end
end
