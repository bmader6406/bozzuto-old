require 'test_helper'
require 'flickr_mocks'

class CommunityTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks
  
  context 'Community' do
    setup do
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
    
    should 'be archivable' do
      assert Community.acts_as_archive?
      assert_nothing_raised do
        Community::Archive
      end
      assert defined?(Community::Archive)
      assert Community::Archive.ancestors.include?(ActiveRecord::Base)
      assert Community::Archive.ancestors.include?(Property::Archive)
    end
    
    should 'report the correct fields for ApartmentCommunity state fields' do
      assert_equal :position, ApartmentCommunity.typus_fields_for('state')['featured_position']
    end
    
    should 'acts_as_list' do
      assert Community.included_modules.include?(ActsAsList::InstanceMethods)
      assert Community.column_names.include?('featured_position')
    end

    context 'when creating a new record' do
      setup { @community = ApartmentCommunity.make_unsaved }

      context 'and featured is false' do
        setup { assert !@community.featured? }

        should 'have a default featured_position of nil' do
          @community.save
          assert_nil @community.featured_position
        end
      end

      context 'and featured is true' do
        setup do
          @community.featured = true
          assert @community.featured?
        end

        should 'have a default featured_position of 1' do
          @community.save
          assert_equal 1, @community.featured_position
        end
      end
    end

    context 'when querying the mobile phone number field' do
      setup do
        @phone_number = '1 (111) 111-1111'
        @community = ApartmentCommunity.make :phone_number => @phone_number
      end

      context 'and no mobile phone number is set' do
        setup { @community.mobile_phone_number = nil }

        should 'return the phone number' do
          assert_equal @phone_number, @community.mobile_phone_number
        end
      end

      context 'and mobile phone number is set' do
        setup do
          @mobile_phone_number = '1 (234) 567-8900'
          @community.mobile_phone_number = @mobile_phone_number
        end

        should 'return the mobile phone number' do
          assert_equal @mobile_phone_number, @community.mobile_phone_number
        end
      end
    end

    context '#twitter_handle' do
      context 'when there is a twitter account' do
        setup do
          @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          @account.save(false)

          @community.twitter_account = @account
        end

        should 'return the twitter username' do
          assert_equal 'TheBozzutoGroup', @community.twitter_handle
        end
      end

      context 'when there is not a twitter account' do
        should 'return nil' do
          assert_nil @community.twitter_handle
        end
      end
    end
    
    context 'with photo set' do
      setup do
        @community = ApartmentCommunity.make
        @set = PhotoSet.make_unsaved(:property => @community)
        @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
        @set.save

        @photo = Photo.make :photo_set => @set
        @photo_group = PhotoGroup.make
        @photo_group.photos << @photo
        @photo_group_not_part_of_community = PhotoGroup.make
      end
      
      context '#photo groups' do
        should 'correctly report groups that have photos for this community' do
          assert_contains @community.photo_groups, @photo_group
          assert_does_not_contain @community.photo_groups, @photo_group_not_part_of_community
        end
      end
      
      context '#photo_groups_and_photos' do
        should 'return photo groups and photos in that groups' do
          assert_contains @community.photo_groups_and_photos.first.last, @photo
        end
      end
    end

    context '#has_overview_bullets?' do
      should 'return false if all bullets are empty' do
        (1..3).each do |i|
          assert_nil @community.send("overview_bullet_#{i}")
        end
        assert !@community.has_overview_bullets?
      end

      should 'return true if any bullets are present' do
        @community.overview_bullet_2 = 'Blah blah blah'
        assert @community.has_overview_bullets?
      end
    end
    
    context '#features_page?' do
      setup do
        @community = ApartmentCommunity.make
      end
      
      should 'return false if there is no features page attached' do
        assert !@community.features_page?
      end

      should 'return true if there is a features page attached' do
        @page = PropertyFeaturesPage.make(:property => @community)
        assert @community.features_page?
      end
    end
    
    context '#neighborhood_page?' do
      setup do
        @community = ApartmentCommunity.make
      end
      
      should 'return false if there is no neighborhood page attached' do
        assert !@community.neighborhood_page?
      end

      should 'return true if there is a neighborhood page attached' do
        @page = PropertyNeighborhoodPage.make(:property => @community)
        assert @community.neighborhood_page?
      end
    end
    
    context '#contact_page?' do
      setup do
        @community = ApartmentCommunity.make
      end
      
      should 'return false if there is no contact page attached' do
        assert !@community.contact_page?
      end

      should 'return true if there is a contact page attached' do
        @page = PropertyContactPage.make(:property => @community)
        assert @community.contact_page?
      end
    end
    
    context '#has_media?' do
      setup do
        @community = ApartmentCommunity.make
      end
      
      context 'without any media' do
        should 'return false' do
          assert !@community.has_media?
        end
      end
      
      context 'with a photo set' do
        setup do
          @flickr_set1 = FlickrSet.new('123', 'Title')
          @flickr_user = mock
          @flickr_user.stubs(:sets).returns([@flickr_set1])
          PhotoSet.stubs(:flickr_user).returns(@flickr_user)
          
          PhotoSet.make(:property => @community, :flickr_set_number => @flickr_set1.id)
        end
        
        should 'return true' do
          assert @community.has_media?
        end
      end
      
      context 'with a video' do
        setup do
          Video.make(:property => @community)
        end
        
        should 'return true' do
          assert @community.has_media?
        end
      end
    end

    context "#apartment_community?" do
      setup do
        @community = Community.new
      end

      should "return false" do
        assert !@community.apartment_community?
      end
    end

    context "#home_community?" do
      setup do
        @community = Community.new
      end

      should "return false" do
        assert !@community.home_community?
      end
    end

    context '#has_active_promo?' do
      setup do
        @active_promo  = Promo.make :active
        @expired_promo = Promo.make :expired
      end

      context 'when promo is not present' do
        should 'return false' do
          assert @community.promo.nil?
          assert !@community.has_active_promo?
        end
      end

      context 'when promo is present and not active' do
        setup { @community.promo = @expired_promo }

        should 'return false' do
          assert !@community.has_active_promo?
        end
      end

      context 'when promo is present and active' do
        setup { @community.promo = @active_promo }

        should 'return true' do
          assert @community.has_active_promo?
        end
      end
    end

    context 'with no Feed' do
      should 'return an empty array on #local_info' do
        assert_nil @community.local_info_feed
        assert_equal [], @community.local_info
      end

      should 'return false on #has_local_reviews?' do
        assert !@community.has_local_info?
      end
    end

    context 'with a Yelp Feed' do
      setup do
        @feed = Feed.make_unsaved
        @feed.expects(:feed_valid?)
        @feed.save

        3.times { FeedItem.make :feed => @feed }
        @community.local_info_feed = @feed
        @community.save
      end

      should 'return the feed items on #local_info' do
        assert_equal 3, @community.local_info.length

        3.times do |i|
          assert_equal @feed.items[i], @community.local_info[i]
        end
      end

      should 'return true on #has_local_info?' do
        assert @community.has_local_info?
      end
    end

    context "with SMSAble mixed in" do
      setup do
        @community.title = "Pearson Square"
        @community.street_address = "410 S. Maple Ave"
        @community.city = City.new(:name => "Falls Church", :state => State.new(:name => "Virginia"))
        @community.phone_number = '888-478-8640'
        @community.website_url = "http://bozzuto.com/pearson"
      end

      should "have a phone message for sms" do
        message = "Pearson Square 410 S. Maple Ave, Falls Church, Virginia 888-478-8640 Call for specials! http://bozzuto.com/pearson"
        assert_equal message, @community.phone_message
      end

      should "have attributes including phone number" do
        @community.stubs(:phone_message).returns("this is a message")
        params = @community.phone_params('1234567890')

        ["to=1234567890", "username=#{APP_CONFIG[:sms]['username']}",
          "pword=#{APP_CONFIG[:sms]['password']}", "sender=#{APP_CONFIG[:sms]['sender']}",
          "message=this+is+a+message"].each do |qs|

          assert params.include?(qs)
        end
      end

      should "send a message to i2sms via get" do
        @community.stubs(:phone_params).returns("params")
        HTTParty.expects(:get).with("#{Bozzuto::SMSAble::URL}?params")
        @community.send_info_message_to('1234567890')
      end

      should "prefix a one to phone number if none is present" do
        HTTParty.stubs(:get)
        @community.stubs(:phone_params).returns("params")

        @community.send_info_message_to('5551234567')
        assert_received(@community, :phone_params) {|e| e.with('15551234567')}
      end

      should "no prefix a one to phone numbers starting with a one" do
        HTTParty.stubs(:get)
        @community.stubs(:phone_params).returns("params")

        @community.send_info_message_to('15550987654')
        assert_received(@community, :phone_params) {|e| e.with('15550987654')}
      end
    end
  end

  context 'The Community class' do
    context 'when searching for communities with a twitter account' do
      setup do
        @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
        @account.save(false)

        @community = ApartmentCommunity.make(:twitter_account => @account)
        @other     = ApartmentCommunity.make
      end

      should 'return only the communities with a twitter account' do
        assert_equal [@community], ApartmentCommunity.with_twitter_account
      end
    end
  end
end
