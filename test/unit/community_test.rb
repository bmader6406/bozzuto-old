require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context "A Community" do
    subject { Community.new }

    should belong_to(:local_info_feed)
    should belong_to(:promo)
    should belong_to(:twitter_account)
    should have_many(:photos)
    should have_many(:videos)
    should have_one(:dnr_configuration)
    should have_one(:features_page)
    should have_one(:neighborhood_page)
    should have_one(:tours_page)
    should have_one(:contact_page)
    should have_one(:conversion_configuration)

    describe "creating a new record" do
      subject { ApartmentCommunity.make_unsaved }

      context "and featured is false" do
        before do
          subject.featured = false
        end

        it "has a default featured_position of nil" do
          subject.save
          subject.featured_position.should == nil
        end
      end

      context "and featured is true" do
        before do
          subject.featured = true
        end

        it "has a default featured_position of 1" do
          subject.save
          subject.featured_position.should == 1
        end
      end
    end

    describe "querying the mobile phone number field" do
      before do
        @phone_number = '1 (111) 111-1111'
      end

      subject { ApartmentCommunity.make(:phone_number => @phone_number) }

      context "and no mobile phone number is set" do
        before do
          subject.mobile_phone_number = nil
        end

        it "returns the phone number" do
          subject.mobile_phone_number.should == @phone_number
        end
      end

      context "and mobile phone number is set" do
        before do
          @mobile_phone_number = '1 (234) 567-8900'

          subject.mobile_phone_number = @mobile_phone_number
        end

        it "returns the mobile phone number" do
          subject.mobile_phone_number.should == @mobile_phone_number
        end
      end
    end

    describe "#twitter_handle" do
      context "when there is a twitter account" do
        before do
          @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          @account.save(:validate => false)

          subject.twitter_account = @account
        end

        it "returns the twitter username" do
          subject.twitter_handle.should == 'TheBozzutoGroup'
        end
      end

      context "when there is not a twitter account" do
        it "returns nil" do
          subject.twitter_handle.should == nil
        end
      end
    end

    describe "#has_overview_bullets?" do
      it "returns false if all bullets are empty" do
        (1..3).each do |i|
          subject.send("overview_bullet_#{i}").should == nil
        end

        subject.has_overview_bullets?.should == false
      end

      it "returns true if any bullets are present" do
        subject.overview_bullet_2 = 'Blah blah blah'

        subject.has_overview_bullets?.should == true
      end
    end

    describe "#features_page?" do
      subject { ApartmentCommunity.make }

      it "return false if there is no features page attached" do
        subject.features_page?.should == false
      end

      it "return true if there is a features page attached" do
        @page = PropertyFeaturesPage.make(:property => subject)

        subject.features_page?.should == true
      end
    end

    describe "#neighborhood_page?" do
      subject { ApartmentCommunity.make }

      it "returns false if there is no neighborhood page attached" do
        subject.neighborhood_page?.should == false
      end

      it "returns true if there is a neighborhood page attached" do
        @page = PropertyNeighborhoodPage.make(:property => subject)

        subject.neighborhood_page?.should == true
      end
    end

    describe "#contact_page?" do
      subject { ApartmentCommunity.make }

      it "returns false if there is no contact page attached" do
        subject.contact_page?.should == false
      end

      it "returns true if there is a contact page attached" do
        @page = PropertyContactPage.make(:property => subject)

        subject.contact_page?.should == true
      end
    end

    describe "#has_media?" do
      subject { ApartmentCommunity.make }

      context "without any media" do
        it "returns false" do
          subject.has_media?.should == false
        end
      end

      context "with a photo" do
        before do
          Photo.make(:property => subject)
        end

        it "returns true" do
          subject.has_media?.should == true
        end
      end

      context "with a video" do
        before do
          Video.make(:property => subject)
        end

        it "returns true" do
          subject.has_media?.should == true
        end
      end
    end

    describe "#apartment_community?" do
      subject { Community.new }

      it "returns false" do
        subject.apartment_community?.should == false
      end
    end

    describe "#home_community?" do
      subject { Community.new }

      it "returns false" do
        subject.home_community?.should == false
      end
    end

    describe "#has_active_promo?" do
      before do
        @active_promo  = Promo.make :active
        @expired_promo = Promo.make :expired
      end

      context "when promo is not present" do
        before do
          subject.promo = nil
        end

        it "returns false" do
          subject.has_active_promo?.should == false
        end
      end

      context "when promo is present and not active" do
        before do
          subject.promo = @expired_promo
        end

        it "returns false" do
          subject.has_active_promo?.should == false
        end
      end

      context "when promo is present and active" do
        before do
          subject.promo = @active_promo
        end

        it "returns true" do
          subject.has_active_promo?.should == true
        end
      end
    end

    context "with no Feed" do
      it "returns an empty array on #local_info" do
        subject.local_info_feed.should == nil
        subject.local_info.should == []
      end

      it "returns false on #has_local_reviews?" do
        subject.has_local_info?.should == false
      end
    end

    context "with a Yelp Feed" do
      before do
        @feed = Feed.make_unsaved
        @feed.expects(:feed_valid?)
        @feed.save

        3.times { FeedItem.make :feed => @feed }
        subject.local_info_feed = @feed
        subject.save
      end

      it "returns the feed items on #local_info" do
        subject.local_info.length.should == 3

        3.times do |i|
          subject.local_info[i].should == @feed.items[i]
        end
      end

      it "returns true on #has_local_info?" do
        subject.has_local_info?.should == true
      end
    end

    context "with SMSAble mixed in" do
      before do
        subject.title          = "Pearson Square"
        subject.street_address = "410 S. Maple Ave"
        subject.city           = City.new(:name => "Falls Church", :state => State.new(:name => "Virginia"))
        subject.phone_number   = '888-478-8640'
        subject.website_url    = "http://bozzuto.com/pearson"
      end

      it "has a phone message for sms" do
        subject.phone_message.should == "Pearson Square 410 S. Maple Ave, Falls Church, Virginia 888-478-8640 Call for specials! http://bozzuto.com/pearson"
      end

      it "has attributes including phone number" do
        subject.stubs(:phone_message).returns("this is a message")

        params = subject.phone_params('1234567890')

        ["to=1234567890", "username=#{APP_CONFIG[:sms]['username']}",
          "pword=#{APP_CONFIG[:sms]['password']}", "sender=#{APP_CONFIG[:sms]['sender']}",
          "message=this+is+a+message"].each do |qs|

          params.include?(qs).should == true
        end
      end

      it "sends a message to i2sms via get" do
        subject.stubs(:phone_params).returns("params")
        HTTParty.expects(:get).with("#{Bozzuto::SMSAble::URL}?params")

        subject.send_info_message_to('1234567890')
      end

      it "prefixes a one to phone number if none is present" do
        HTTParty.stubs(:get)
        subject.expects(:phone_params).with('15551234567')

        subject.send_info_message_to('5551234567')
      end

      it "doesn't prefix a one to phone numbers starting with a one" do
        HTTParty.stubs(:get)
        subject.expects(:phone_params).with('15550987654')

        subject.send_info_message_to('15550987654')
      end
    end
  end

  context "The Community class" do
    context "when searching for communities with a twitter account" do
      before do
        @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
        @account.save(:validate => false)

        @community = ApartmentCommunity.make(:twitter_account => @account)
        @other     = ApartmentCommunity.make
      end

      it "returns only the communities with a twitter account" do
        ApartmentCommunity.with_twitter_account.should == [@community]
      end
    end
  end
end
