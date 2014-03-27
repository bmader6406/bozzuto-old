require 'test_helper'

class SmsMessagesControllerTest < ActionController::TestCase
  context "the SmsMessages controller" do
    describe "GET to #new" do
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
    
    describe "POST to #create" do
      desktop_device do
        context "for a HomeCommunity" do
          before do
            HomeCommunity.any_instance.expects(:send_info_message_to).once.with('1234567890')

            @community = HomeCommunity.make

            post :create,
                 :home_community_id => @community.id,
                 :phone_number      => '1234567890'
          end

          should_redirect_to('thank you page') { thank_you_home_community_sms_message_path(@community) }
        end

        context "for an ApartmentCommunity" do
          setup do
            ApartmentCommunity.any_instance.expects(:send_info_message_to).once.with('1234567890')

            @community = ApartmentCommunity.make

            post :create,
              :apartment_community_id => @community.id,
              :phone_number           => '1234567890'
          end

          should_redirect_to('thank you page') { thank_you_apartment_community_sms_message_path(@community) }
        end

        context "without a phone number" do
          setup do
            @community = HomeCommunity.make

            post :create,
                 :home_community_id => @community.id,
                 :phone_number      => ''
          end

          should_redirect_to('main community page') { home_community_path(@community) }

          it "sets an error in the flash" do
            flash[:send_to_phone_errors].present?.should == true
          end
        end
      end
      
      mobile_device do
        context "for a HomeCommunity" do
          setup do
            HomeCommunity.any_instance.expects(:send_info_message_to).once.with('1234567890')

            @community = HomeCommunity.make

            post :create,
                 :home_community_id => @community.to_param,
                 :phone_number      => '1234567890'
          end

          should_respond_with :success
          should_render_template :thank_you
          should_render_with_layout :application
        end

        context "for an ApartmentCommunity" do
          setup do
            ApartmentCommunity.any_instance.expects(:send_info_message_to).once.with('1234567890')

            @community = ApartmentCommunity.make

            post :create,
                 :apartment_community_id => @community.to_param,
                 :phone_number           => '1234567890'
          end

          should_respond_with :success
          should_render_template :thank_you
          should_render_with_layout :application
        end

        context "without a phone number" do
          setup do
            @community = HomeCommunity.make

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

    context 'GET to #thank_you' do
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
