require 'test_helper'

class CommunityListingMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  default_url_options[:host] = 'bozzuto.com'

  context "CommunityListingMailer" do
    describe "#single_listing" do
      [ApartmentCommunity, HomeCommunity].each do |klass|
        context "with a #{klass.model_name.human}" do
          before do
            @to        = Faker::Internet.email
            @community = klass.make

            expect {
              @email = CommunityListingMailer.single_listing(@to, @community).deliver
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end

          it "sets the from address" do
            @email.from.should == [BOZZUTO_EMAIL_ADDRESS]
          end

          it "sets the reply to header" do
            @email.reply_to.should == [BOZZUTO_REPLY_TO]
          end

          it "delivers the message" do
            @email.to.should == [@to]
          end

          it "has the community title as subject" do
            @email.subject.should == @community.title
          end

          it "has a link to the community in the body" do
            @email.body.should =~ %r{/communities/#{@community.to_param}}
          end
        end
      end
    end


    describe '#recently_viewed_listings' do
      before do
        @property_1      = ApartmentCommunity.make(:title => "My Fake Condos")
        @property_2      = ApartmentCommunity.make(:title => "Bogus Community")
        @recurring_email = RecurringEmail.make :property_ids => [@property_1.id, @property_2.id]

        expect {
          @email = CommunityListingMailer.recently_viewed_listings(@recurring_email).deliver
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "sets the from address" do
        @email.from.should == [BOZZUTO_EMAIL_ADDRESS]
      end

      it "sets the reply to header" do
        @email.reply_to.should == [BOZZUTO_REPLY_TO]
      end

      it "delivers the message to the correct recipient" do
        @email.to.should == [@recurring_email.email_address]
      end

      it "has the subject" do
        @email.subject.should == 'Recently Viewed Apartment Communities'
      end

      it "has the property titles in the body" do
        @email.body.should =~ /#{@property_1.title}/
        @email.body.should =~ /#{@property_2.title}/
      end

      it "has a link to the properties in the body" do
        @email.body.should =~ %r{/apartments/communities/#{@property_1.to_param}}
        @email.body.should =~ %r{/apartments/communities/#{@property_2.to_param}}
      end
    end

    describe '#search_results_listings' do
      setup do
        @property_1      = ApartmentCommunity.make :title => 'Property #1'
        @property_2      = ApartmentCommunity.make :title => 'Property #2'
        @recurring_email = RecurringEmail.make(:recurring, :property_ids => [@property_1.id, @property_2.id])

        expect {
          @email = CommunityListingMailer.search_results_listings(@recurring_email).deliver
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "sets the from address" do
        @email.from.should == [BOZZUTO_EMAIL_ADDRESS]
      end

      it "sets the reply to header" do
        @email.reply_to.should == [BOZZUTO_REPLY_TO]
      end

      it "delivers the message" do
        @email.to.should == [@recurring_email.email_address]
      end

      it "has the subject" do
        @email.subject.should == 'Apartment Communities Search Results'
      end

      it "has the property titles in the body" do
        @email.body.should =~ /#{@property_1.title}/
        @email.body.should =~ /#{@property_2.title}/
      end

      it "has a link to the properties in the body" do
        @email.body.should =~ %r{/apartments/communities/#{@property_1.to_param}}
        @email.body.should =~ %r{/apartments/communities/#{@property_2.to_param}}
      end
    end


    context "helper methods" do
      before do
        @mailer    = CommunityListingMailer.send(:new)
        @community = ApartmentCommunity.make
      end

      context "#floor_plans_url" do
        context "with a home community" do
          before do
            @community = HomeCommunity.make
          end

          it "returns home_community_homes_url" do
            url = home_community_homes_url(@community)

            @mailer.send(:floor_plans_url, @community).should == url
          end
        end

        context "with an apartment community" do
          before do
            @community = ApartmentCommunity.make
          end

          it "returns apartment_community_floor_plan_groups_url" do
            url = apartment_community_floor_plan_groups_url(@community)

            @mailer.send(:floor_plans_url, @community).should == url
          end
        end
      end

      context "#tel_url" do
        context "a number has non-numeric characters" do
          it "strips those from the number" do
            @mailer.send(:tel_url, '1 (888) 123-4567').should == 'tel:+18881234567'
          end
        end

        context "a number does not have a leading 1" do
          it "adds the leading 1" do
            @mailer.send(:tel_url, '888.123.4567').should == 'tel:+18881234567'
          end
        end
      end
    end
  end
end
