require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  context 'Feed' do
    before do
      @fixture = load_fixture_file('rss_multiple_items.rss')
      @rss     = Bozzuto::RssFetcher::RssParser.call(@fixture, :xml)
      @items   = @rss['rss']['channel']['item']

      @url = Sham.feed_url

      @existing_feed = Feed.make_unsaved.tap do |feed|
        stub_request(:get, feed.url).to_return(
          :body    => @fixture,
          :headers => { 'Content-Type' => 'text/xml' }
        )

        feed.save
      end
    end

    subject { Feed.new }

    should_have_many :items, :dependent => :destroy
    should_have_many :properties

    should_validate_presence_of :name, :url
    should_validate_uniqueness_of :url

    describe "#typus_name" do
      it "returns the name" do
        subject.name = 'Hooray'

        assert_equal subject.name, subject.typus_name
      end
    end

    describe "before validating" do
      before do
        subject.url = " \thttp://yay.com\t\t "
        subject.expects(:feed_valid?)
      end

      it "strips whitespace" do
        subject.valid?

        assert_equal 'http://yay.com', subject.url
      end
    end

    describe "validating on create" do
      before do
        subject.name = 'The Feed'
        subject.url  = @url
      end

      context "feed is not found" do
        before do
          stub_request(:get, subject.url).to_return(
            :status  => 404,
            :body    => '',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "sets the error message" do
          assert !subject.valid?
          assert_equal 'could not be found', subject.errors.on(:url)
        end
      end

      context "feed is invalid" do
        before do
          stub_request(:get, subject.url).to_return(
            :body    => '<yay>hooray',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "sets the error message" do
          assert !subject.valid?
          assert_equal 'is not a valid RSS feed', subject.errors.on(:url)
        end
      end

      context "feed is valid" do
        before do
          stub_request(:get, subject.url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "is valid" do
          assert subject.valid?
          assert_nil subject.errors.on(:url)
        end
      end
    end

    describe "#refresh!" do
      before do
        subject.name = 'The Feed'
        subject.url  = @url

        subject.expects(:feed_valid?).returns(true)

        subject.save
      end

      context "feed is not found" do
        before do
          stub_request(:get, subject.url).to_return(
            :status  => 404,
            :body    => '',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "raises an exception" do
          assert_raises(Feed::FeedNotFound) do
            subject.refresh!
          end
        end
      end

      context "feed is invalid" do
        before do
          stub_request(:get, subject.url).to_return(
            :body    => '<yay>hooray',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "raises an exception" do
          assert_raises(Feed::InvalidFeed) do
            subject.refresh!
          end
        end
      end

      context "feed is valid" do
        before do
          stub_request(:get, subject.url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "creates all the items" do
          subject.refresh!

          subject.items.zip(@items).each do |actual, expected|
            assert_equal expected['title'], actual.title
            assert_equal expected['link'],  actual.url

            assert_equal Nokogiri::HTML(expected['description']).content, actual.description

            # must send #to_s here for Yahoo Pipes janky RSS feed
            assert_equal Time.zone.parse(expected['pubDate'].to_s).rfc822, actual.published_at.rfc822
          end
        end
      end
    end
  end
end
