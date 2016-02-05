require 'test_helper'

class CommunityListingEmailsControllerTest < ActionController::TestCase
  context "on POST to create" do
    context "without an email address" do
      setup do
        @community = HomeCommunity.make
      end

      should "not send an email" do
        expect {
          post :create,
            :home_community_id => @community.id,
            :email             => ''
        }.to_not change { ActionMailer::Base.deliveries.count }
      end

      should "redirect to the main community page" do
        post :create, :home_community_id => @community.id, :email => ''

        response.should redirect_to(home_community_path(@community))
      end

      should "set an error in the flash" do
        post :create, :home_community_id => @community.id, :email => ''

        flash[:send_listing_errors].should == true
      end
    end

    context "for a HomeCommunity" do
      setup do
        @community = HomeCommunity.make
        @email = Faker::Internet.email
      end

      context "with 'newsletter' unchecked" do
        should "send an email without signing them up for Bozzuto Buzz" do
          expect {
            expect {
              post :create,
                :home_community_id => @community.id,
                :email             => @email
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          }.to_not change { Buzz.count }
        end

        should "redirects to the thank you page" do
          post :create, :home_community_id => @community.id, :email => @email

          response.should redirect_to(thank_you_home_community_email_listing_path(@community))
        end

        should "save the email address in the flash" do
          post :create, :home_community_id => @community.id, :email => @email

          flash[:send_listing_email].should == @email
        end
      end

      context "with 'newsletter' checked" do
        should "send an email and sign them up for Bozzuto Buzz" do
          expect {
            expect {
              post :create,
                   :home_community_id => @community.id,
                   :email             => @email,
                   :newsletter        => true
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          }.to change { Buzz.count }.by(1)
        end

        should "redirects to the thank you page" do
          post :create,
               :home_community_id => @community.id,
               :email             => @email,
               :newsletter        => true

          response.should redirect_to(thank_you_home_community_email_listing_path(@community))
        end


        should "saves the email address in the flash" do
          post :create,
               :home_community_id => @community.id,
               :email             => @email,
               :newsletter        => true

          flash[:send_listing_email].should == @email
        end
      end
    end

    context "for an ApartmentCommunity" do
      setup do
        @community = ApartmentCommunity.make
        @email = Faker::Internet.email
      end

      should "send an email" do
        expect {
          post :create, :apartment_community_id => @community.id, :email => @email
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      should "redirects to the thank you page" do
        post :create, :apartment_community_id => @community.id, :email => @email

        response.should redirect_to(thank_you_apartment_community_email_listing_path(@community))
      end


      should "saves the email address in the flash" do
        post :create, :apartment_community_id => @community.id, :email => @email

        flash[:send_listing_email].should == @email
      end
    end
  end

  context 'a GET to thank_you' do
    setup do
      @community = HomeCommunity.make

      get :thank_you, :home_community_id => @community.id
    end

    should respond_with(:success)
    should render_template(:thank_you)
  end
end
