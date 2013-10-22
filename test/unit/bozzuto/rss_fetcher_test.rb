require 'test_helper'

class Bozzuto::RssFetcherTest < ActiveSupport::TestCase
  context 'RSS Fetcher' do
    before do
      @url = 'http://url.com'
    end

    subject { Bozzuto::RssFetcher.new(@url) }

    describe "#found?" do
      context "response code is 200" do
        before do
          subject.expects(:response).returns(stub(:code => 200))
        end

        it "returns true" do
          assert subject.found?
        end
      end

      context "response code is anything else" do
        before do
          subject.expects(:response).returns(stub(:code => 404))
        end

        it "returns false" do
          assert !subject.found?
        end
      end
    end

    describe "#response" do
      before do
        @fixture = load_fixture_file('rss_multiple_items.rss')

        stub_request(:get, @url).to_return(
          :body    => @fixture,
          :headers => { 'Content-Type' => 'text/xml' }
        )
      end

      it "loads the response" do
        assert_equal @fixture, subject.response.body
        assert_equal 200, subject.response.code
      end
    end

    describe "#feed_valid?" do
      context "with a valid feed" do
        before do
          @fixture = load_fixture_file('rss_multiple_items.rss')

          stub_request(:get, @url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns true" do
          assert subject.feed_valid?
        end
      end

      context "body is empty" do
        before do
          stub_request(:get, @url).to_return(
            :body    => '',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns false" do
          assert !subject.feed_valid?
        end
      end

      context "body doesn't contain the RSS node" do
        before do
          stub_request(:get, @url).to_return(
            :body    => '<yay>hooray</yay>',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns false" do
          assert !subject.feed_valid?
        end
      end

      context "body contains invalid XML" do
        before do
          stub_request(:get, @url).to_return(
            :body    => '<yay>hooray',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns false" do
          assert !subject.feed_valid?
        end
      end
    end

    describe "#items" do
      context "feed contains multiple items" do
        before do
          @fixture = load_fixture_file('rss_multiple_items.rss')
          @rss     = Bozzuto::RssFetcher::RssParser.call(@fixture, :xml)
          @items   = @rss['rss']['channel']['item']

          stub_request(:get, @url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns all the items" do
          assert_equal @items, subject.items
        end
      end

      context "feed contains one item" do
        before do
          @fixture = load_fixture_file('rss_one_item.rss')
          @rss     = Bozzuto::RssFetcher::RssParser.call(@fixture, :xml)
          @items   = @rss['rss']['channel']['item']

          stub_request(:get, @url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns the one item, in an array" do
          assert_equal [@items], subject.items
        end
      end

      context "feed contains zero items" do
        before do
          @fixture = load_fixture_file('rss_no_items.rss')

          stub_request(:get, @url).to_return(
            :body    => @fixture,
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns an empty array" do
          assert_equal [], subject.items
        end
      end

      context "feed is invalid" do
        before do
          stub_request(:get, @url).to_return(
            :body    => '<yay>hooray',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        it "returns an empty array" do
          assert_equal [], subject.items
        end
      end
    end
  end
end
