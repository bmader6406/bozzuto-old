require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  context 'Community' do
    setup do
      @community = Community.new
    end

    subject { @community }

    should_belong_to :local_info_feed, :promo
    should_have_one :photo_set
    should_have_many :videos

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
        @community.website_url = "http://bozzuto.com/pearson"
      end

      should "have a phone message for sms" do
        message = "Pearson Square\n410 S. Maple Ave, Falls Church, Virginia\nhttp://bozzuto.com/pearson"
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
