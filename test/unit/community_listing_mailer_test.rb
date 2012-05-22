require 'test_helper'

class CommunityListingMailerTest < ActionMailer::TestCase
  include ActionController::UrlWriter
  default_url_options[:host] = 'bozzuto.com'

  context "CommunityListingMailer" do
    setup do
      @community = ApartmentCommunity.make
    end

    context "#single_listing" do
      setup do
        @to = Faker::Internet.email

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

    context 'url helpers' do
      setup do
        @mailer = CommunityListingMailer.send(:new)
      end

      context '#community_url' do
        context 'with a home community' do
          setup { @community = HomeCommunity.make }

          should 'return home_community_url' do
            assert_equal home_community_url(@community), @mailer.send(:community_url, @community)
          end
        end

        context 'with an apartment community' do
          setup { @community = ApartmentCommunity.make }

          should 'return apartment_community_url' do
            assert_equal apartment_community_url(@community), @mailer.send(:community_url, @community)
          end
        end
      end

      context '#offers_url' do
        setup { @community = ApartmentCommunity.make }

        should 'return the ufollowup_url' do
          assert_equal ufollowup_url(@community.id), @mailer.send(:offers_url, @community)
        end
      end

      context '#floor_plans_url' do
        context 'with a home community' do
          setup { @community = HomeCommunity.make }

          should 'return home_community_homes_url' do
            assert_equal home_community_homes_url(@community), @mailer.send(:floor_plans_url, @community)
          end
        end

        context 'with an apartment community' do
          setup { @community = ApartmentCommunity.make }

          should 'return apartment_community_floor_plan_groups_url' do
            assert_equal apartment_community_floor_plan_groups_url(@community), @mailer.send(:floor_plans_url, @community)
          end
        end
      end
    end
  end
end
