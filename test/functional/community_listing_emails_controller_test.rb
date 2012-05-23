require 'test_helper'

class CommunityListingEmailsControllerTest < ActionController::TestCase
  context "on POST to create" do
    context "without an email address" do
      setup do
        @community = HomeCommunity.make

        post :create,
          :home_community_id => @community.id,
          :email             => ''
      end

      should_redirect_to('main community page') { home_community_path(@community) }

      should_not_change('the number of emails') { ActionMailer::Base.deliveries.count }

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
          post :create,
            :home_community_id => @community.id,
            :email             => @email
        end

        should_redirect_to('thank you page') {
          thank_you_home_community_email_listing_path(@community)
        }

        should_change('the number of emails', :by => 1) { ActionMailer::Base.deliveries.count }

        should_not_change('the number of buzz emails') { Buzz.count }

        should 'save the email address in the flash' do
          assert_equal @email, flash[:send_listing_email]
        end
      end

      context "with 'newsletter' checked" do
        setup do
          post :create,
            :home_community_id => @community.id,
            :email             => @email,
            :newsletter        => true
        end

        should_redirect_to('thank you page') {
          thank_you_home_community_email_listing_path(@community)
        }

        should_change('the number of emails', :by => 1) { ActionMailer::Base.deliveries.count }

        should_change('the number of buzz emails', :by => 1) { Buzz.count }

        should 'save the email address in the flash' do
          assert_equal @email, flash[:send_listing_email]
        end
      end
    end

    context "for an ApartmentCommunity" do
      setup do
        @community = ApartmentCommunity.make
        @email = Faker::Internet.email

        post :create,
          :apartment_community_id => @community.id,
          :email                  => @email
      end

      should_redirect_to('thank you page') {
        thank_you_apartment_community_email_listing_path(@community)
      }

      should_change('the number of emails', :by => 1) { ActionMailer::Base.deliveries.count }

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

    should_respond_with :success
    should_render_template :thank_you
  end
end
