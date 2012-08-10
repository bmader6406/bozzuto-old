require 'test_helper'

class CommunityListingMailerTest < ActionMailer::TestCase
  include ActionController::UrlWriter
  default_url_options[:host] = 'bozzuto.com'

  context "CommunityListingMailer" do

    context "#single_listing" do
      [ApartmentCommunity, HomeCommunity].each do |klass|
        context "with a #{klass.human_name}" do
          setup do
            @to        = Faker::Internet.email
            @community = klass.make

            assert_difference('ActionMailer::Base.deliveries.count', 1) do
              @email = CommunityListingMailer.deliver_single_listing(@to, @community)
            end
          end

          should "deliver the message" do
            assert_equal [@to], @email.to
          end

          should "have the community title as subject" do
            assert_equal @community.title, @email.subject
          end

          should "have a link to the community in the body" do
            assert_match /\/communities\/#{@community.to_param}/, @email.body
          end
        end
      end
    end

    context '#recently_viewed_listings' do
      setup do
        @property_1      = ApartmentCommunity.make
        @property_2      = ApartmentCommunity.make
        @recurring_email = RecurringEmail.make :property_ids => [@property_1.id, @property_2.id]

        assert_difference('ActionMailer::Base.deliveries.count', 1) do
          @email = CommunityListingMailer.deliver_recently_viewed_listings(@recurring_email)
        end
      end

      should "deliver the message" do
        assert_equal [@recurring_email.email_address], @email.to
      end

      should "have the subject" do
        assert_equal 'Recently Viewed Apartment Communities', @email.subject
      end

      should "have the property titles in the body" do
        assert_match /#{@property_1.title}/, @email.body
        assert_match /#{@property_2.title}/, @email.body
      end

      should "have a link to the properties in the body" do
        assert_match %r{/apartments/communities/#{@property_1.to_param}}, @email.body
        assert_match %r{/apartments/communities/#{@property_2.to_param}}, @email.body
      end
    end

    context 'helper methods' do
      setup do
        @mailer = CommunityListingMailer.send(:new)
        @community = ApartmentCommunity.make
      end

      context '#floor_plans_url' do
        context 'with a home community' do
          setup do
            @community = HomeCommunity.make
          end

          should 'return home_community_homes_url' do
            url = home_community_homes_url(@community)

            assert_equal url, @mailer.send(:floor_plans_url, @community)
          end
        end

        context 'with an apartment community' do
          setup do
            @community = ApartmentCommunity.make
          end

          should 'return apartment_community_floor_plan_groups_url' do
            url = apartment_community_floor_plan_groups_url(@community)

            assert_equal url, @mailer.send(:floor_plans_url, @community)
          end
        end
      end

      context '#tel_url' do
        context 'a number has non-numeric characters' do
          should 'strip those from the number' do
            assert_equal 'tel:+18881234567', @mailer.send(:tel_url, '1 (888) 123-4567')
          end
        end

        context 'a number does not have a leading 1' do
          should 'add the leading 1' do
            assert_equal 'tel:+18881234567', @mailer.send(:tel_url, '888.123.4567')
          end
        end
      end
    end
  end
end
