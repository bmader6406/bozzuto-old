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

    should have_many(:items).dependent(:destroy)
    should have_many(:properties)

    should validate_presence_of(:name)

    should validate_presence_of(:url)
    should validate_uniqueness_of(:url)

    describe "#to_s" do
      it "returns the name" do
        subject.name = 'Hooray'

        subject.to_s.should == 'Hooray'
      end
    end

    describe "before validating" do
      before do
        subject.url = " \thttp://yay.com\t\t "
        subject.expects(:feed_valid?)
      end

      it "strips whitespace" do
        subject.valid?

        subject.url.should == 'http://yay.com'
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
          subject.valid?.should == false

          subject.errors[:url].should include('could not be found')
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
          subject.valid?.should == false

          subject.errors[:url].should include('is not a valid RSS feed')
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
          subject.valid?.should == true

          subject.errors[:url].should == []
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
          expect {
            subject.refresh!
          }.to raise_error(Feed::FeedNotFound)
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
          expect {
            subject.refresh!
          }.to raise_error(Feed::InvalidFeed)
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
            actual.title.should == expected['title']
            actual.url.should == expected['link']

            actual.description.should == Nokogiri::HTML(expected['description']).content

            # must send #to_s here for Yahoo Pipes janky RSS feed
            actual.published_at.rfc822.should == Time.zone.parse(expected['pubDate'].to_s).rfc822
          end
        end
      end
    end
  end
end
