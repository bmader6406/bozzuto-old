require 'test_helper'
require 'flickr_mocks'

class CommunityTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks

  context "A Community" do
    before do
      @community = Community.new
    end

    subject { @community }

    should_belong_to :local_info_feed, :promo, :twitter_account
    should_have_one :photo_set
    should_have_many :videos
    should_have_one :dnr_configuration
    should_have_one :features_page
    should_have_one :neighborhood_page
    should_have_one :tours_page
    should_have_one :contact_page
    should_have_one :conversion_configuration
    should_have_many :photos, :through => :photo_set

    describe "creating a new record" do
      before { @community = ApartmentCommunity.make_unsaved }

      context "and featured is false" do
        before do
          @community.featured = false
        end

        it "has a default featured_position of nil" do
          @community.save
          @community.featured_position.should == nil
        end
      end

      context "and featured is true" do
        before do
          @community.featured = true
        end

        it "has a default featured_position of 1" do
          @community.save
          @community.featured_position.should == 1
        end
      end
    end

    describe "querying the mobile phone number field" do
      before do
        @phone_number = '1 (111) 111-1111'

        @community = ApartmentCommunity.make(:phone_number => @phone_number)
      end

      context "and no mobile phone number is set" do
        before do
          @community.mobile_phone_number = nil
        end

        it "returns the phone number" do
          @community.mobile_phone_number.should == @phone_number
        end
      end

      context "and mobile phone number is set" do
        before do
          @mobile_phone_number = '1 (234) 567-8900'

          @community.mobile_phone_number = @mobile_phone_number
        end

        it "returns the mobile phone number" do
          @community.mobile_phone_number.should == @mobile_phone_number
        end
      end
    end

    describe "#twitter_handle" do
      context "when there is a twitter account" do
        before do
          @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          @account.save(false)

          @community.twitter_account = @account
        end

        it "returns the twitter username" do
          @community.twitter_handle.should == 'TheBozzutoGroup'
        end
      end

      context "when there is not a twitter account" do
        it "returns nil" do
          @community.twitter_handle.should == nil
        end
      end
    end

    context "with photo set" do
      before do
        @community = ApartmentCommunity.make
        @set = PhotoSet.make_unsaved(:property => @community)
        @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
        @set.save

        @photo = Photo.make :photo_set => @set
        @photo_group = PhotoGroup.make
        @photo_group.photos << @photo
        @photo_group_not_part_of_community = PhotoGroup.make
      end

      describe "#photo groups" do
        it "correctly reports the groups that have photos for this community" do
          assert_contains @community.photo_groups, @photo_group
          assert_does_not_contain @community.photo_groups, @photo_group_not_part_of_community
        end
      end

      describe "#photo_groups_and_photos" do
        it "returns photo groups and photos in that groups" do
          assert_contains @community.photo_groups_and_photos.first.last, @photo
        end
      end
    end

    describe "#has_overview_bullets?" do
      it "returns false if all bullets are empty" do
        (1..3).each do |i|
          @community.send("overview_bullet_#{i}").should == nil
        end

        @community.has_overview_bullets?.should == false
      end

      it "returns true if any bullets are present" do
        @community.overview_bullet_2 = 'Blah blah blah'

        @community.has_overview_bullets?.should == true
      end
    end

    describe "#features_page?" do
      before do
        @community = ApartmentCommunity.make
      end

      it "return false if there is no features page attached" do
        @community.features_page?.should == false
      end

      it "return true if there is a features page attached" do
        @page = PropertyFeaturesPage.make(:property => @community)

        @community.features_page?.should == true
      end
    end

    describe "#neighborhood_page?" do
      before do
        @community = ApartmentCommunity.make
      end

      it "returns false if there is no neighborhood page attached" do
        @community.neighborhood_page?.should == false
      end

      it "returns true if there is a neighborhood page attached" do
        @page = PropertyNeighborhoodPage.make(:property => @community)

        @community.neighborhood_page?.should == true
      end
    end

    describe "#contact_page?" do
      before do
        @community = ApartmentCommunity.make
      end

      it "returns false if there is no contact page attached" do
        @community.contact_page?.should == false
      end

      it "returns true if there is a contact page attached" do
        @page = PropertyContactPage.make(:property => @community)

        @community.contact_page?.should == true
      end
    end

    describe "#has_media?" do
      before do
        @community = ApartmentCommunity.make
      end

      context "without any media" do
        it "returns false" do
          @community.has_media?.should == false
        end
      end

      context "with a photo set" do
        before do
          @flickr_set1 = FlickrSet.new('123', 'Title')
          @flickr_user = mock
          @flickr_user.stubs(:sets).returns([@flickr_set1])

          PhotoSet.stubs(:flickr_user).returns(@flickr_user)

          PhotoSet.make(:property => @community, :flickr_set_number => @flickr_set1.id)
        end

        it "returns true" do
          @community.has_media?.should == true
        end
      end

      context "with a video" do
        before do
          Video.make(:property => @community)
        end

        it "returns true" do
          @community.has_media?.should == true
        end
      end
    end

    describe "#apartment_community?" do
      before do
        @community = Community.new
      end

      it "returns false" do
        @community.apartment_community?.should == false
      end
    end

    describe "#home_community?" do
      before do
        @community = Community.new
      end

      it "returns false" do
        @community.home_community?.should == false
      end
    end

    describe "#has_active_promo?" do
      before do
        @active_promo  = Promo.make :active
        @expired_promo = Promo.make :expired
      end

      context "when promo is not present" do
        before do
          @community.promo = nil
        end

        it "returns false" do
          @community.has_active_promo?.should == false
        end
      end

      context "when promo is present and not active" do
        before do
          @community.promo = @expired_promo
        end

        it "returns false" do
          @community.has_active_promo?.should == false
        end
      end

      context "when promo is present and active" do
        before do
          @community.promo = @active_promo
        end

        it "returns true" do
          @community.has_active_promo?.should == true
        end
      end
    end

    context "with no Feed" do
      it "returns an empty array on #local_info" do
        @community.local_info_feed.should == nil
        @community.local_info.should == []
      end

      it "returns false on #has_local_reviews?" do
        @community.has_local_info?.should == false
      end
    end

    context "with a Yelp Feed" do
      before do
        @feed = Feed.make_unsaved
        @feed.expects(:feed_valid?)
        @feed.save

        3.times { FeedItem.make :feed => @feed }
        @community.local_info_feed = @feed
        @community.save
      end

      it "returns the feed items on #local_info" do
        @community.local_info.length.should == 3

        3.times do |i|
          @community.local_info[i].should == @feed.items[i]
        end
      end

      it "returns true on #has_local_info?" do
        @community.has_local_info?.should == true
      end
    end

    context "with SMSAble mixed in" do
      before do
        @community.title          = "Pearson Square"
        @community.street_address = "410 S. Maple Ave"
        @community.city           = City.new(:name => "Falls Church", :state => State.new(:name => "Virginia"))
        @community.phone_number   = '888-478-8640'
        @community.website_url    = "http://bozzuto.com/pearson"
      end

      it "has a phone message for sms" do
        @community.phone_message.should == "Pearson Square 410 S. Maple Ave, Falls Church, Virginia 888-478-8640 Call for specials! http://bozzuto.com/pearson"
      end

      it "has attributes including phone number" do
        @community.stubs(:phone_message).returns("this is a message")

        params = @community.phone_params('1234567890')

        ["to=1234567890", "username=#{APP_CONFIG[:sms]['username']}",
          "pword=#{APP_CONFIG[:sms]['password']}", "sender=#{APP_CONFIG[:sms]['sender']}",
          "message=this+is+a+message"].each do |qs|

          params.include?(qs).should == true
        end
      end

      it "sends a message to i2sms via get" do
        @community.stubs(:phone_params).returns("params")
        HTTParty.expects(:get).with("#{Bozzuto::SMSAble::URL}?params")

        @community.send_info_message_to('1234567890')
      end

      it "prefixes a one to phone number if none is present" do
        HTTParty.stubs(:get)
        @community.expects(:phone_params).with('15551234567')

        @community.send_info_message_to('5551234567')
      end

      it "doesn't prefix a one to phone numbers starting with a one" do
        HTTParty.stubs(:get)
        @community.expects(:phone_params).with('15550987654')

        @community.send_info_message_to('15550987654')
      end
    end
  end

  context "The Community class" do
    context "when searching for communities with a twitter account" do
      before do
        @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
        @account.save(false)

        @community = ApartmentCommunity.make(:twitter_account => @account)
        @other     = ApartmentCommunity.make
      end

      it "returns only the communities with a twitter account" do
        ApartmentCommunity.with_twitter_account.should == [@community]
      end
    end
  end
end
