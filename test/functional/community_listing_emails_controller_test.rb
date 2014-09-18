require 'test_helper'

class CommunityListingEmailsControllerTest < ActionController::TestCase
  context "on POST to create" do
    context "without an email address" do
      setup do
        @community = HomeCommunity.make

        expect {
          post :create,
            :home_community_id => @community.id,
            :email             => ''
        }.to_not change { ActionMailer::Base.deliveries.count }
      end

      should redirect_to('main community page') { home_community_path(@community) }

      should 'set an error in the flash' do
        assert flash[:send_listing_errors]
      end
    end

    context "for a HomeCommunity" do
      setup do
        @community = HomeCommunity.make
        @email = Faker::Internet.email
      end

      context "with 'newsletter' unchecked" do
        setup do
          expect {
            expect {
              post :create,
                :home_community_id => @community.id,
                :email             => @email
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          }.to_not change { Buzz.count }
        end

        should redirect_to('thank you page') {
          thank_you_home_community_email_listing_path(@community)
        }


        should 'save the email address in the flash' do
          assert_equal @email, flash[:send_listing_email]
        end
      end

      context "with 'newsletter' checked" do
        setup do
          expect {
            expect {
              post :create,
                   :home_community_id => @community.id,
                   :email             => @email,
                   :newsletter        => true
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          }.to change { Buzz.count }.by(1)
        end

        should redirect_to('thank you page') {
          thank_you_home_community_email_listing_path(@community)
        }


        should 'save the email address in the flash' do
          assert_equal @email, flash[:send_listing_email]
        end
      end
    end

    context "for an ApartmentCommunity" do
      setup do
        @community = ApartmentCommunity.make
        @email = Faker::Internet.email

        expect {
          post :create,
            :apartment_community_id => @community.id,
            :email                  => @email
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      should redirect_to('thank you page') {
        thank_you_apartment_community_email_listing_path(@community)
      }


      should 'save the email address in the flash' do
        assert_equal @email, flash[:send_listing_email]
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
