require 'test_helper'
require 'flickr_mocks'

class CommunityTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks
  
  context 'Community' do
    setup do
      @community = Community.new
    end

    subject { @community }

    should_belong_to :local_info_feed, :promo
    should_have_one :photo_set
    should_have_many :videos
    should_have_one :dnr_configuration
    should_have_one :features_page
    should_have_one :neighborhood_page
    should_have_one :contact_page
    
    should_have_named_scope 'sort_for(LandingPage.make(:randomize_property_listings => true))',
      :order => 'RAND(NOW())'
    should_have_named_scope 'sort_for(LandingPage.make(:randomize_property_listings => false))',
      :order => 'properties.title ASC'
    should_have_named_scope 'sort_for(Page.make)', {}
    
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
        @feed.expects(:validate_on_create)
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
end
