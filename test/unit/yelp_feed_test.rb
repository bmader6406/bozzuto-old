require 'test_helper'

class YelpFeedTest < ActiveSupport::TestCase
  context 'A YelpFeed' do
    setup do
      @fixture = load_fixture_file('yelp.rss')
      @rss     = YelpFeed::Parser.call(@fixture, :xml)
      @url     = Sham.feed_url

      stub_request(:get, @url).to_return(
        :body    => @fixture,
        :headers => { 'Content-Type' => 'text/xml' }
      )
      @feed = YelpFeed.make :url => @url
    end

    subject { @feed }

    should_have_many :items, :dependent => :destroy
    should_have_many :properties

    should_validate_presence_of :url
    should_validate_uniqueness_of :url


    context 'when validating on create' do
      setup do
        @url = Sham.feed_url
        @feed = YelpFeed.new :url => @url
      end

      context 'and url cannot be found' do
        setup do
          stub_request(:get, @url).to_return(:status => 404)
        end

        should 'have errors' do
          assert @feed.invalid?
          assert @feed.errors.on(:url)
          assert @feed.errors.on(:url).any? { |err| err =~ /not be found/ }
        end
      end

      context 'and url is not valid RSS' do
        setup do
          stub_request(:get, @url).to_return(
            :status  => 200,
            :body    => 'blah blah blah',
            :headers => { 'Content-Type' => 'text/xml' }
          )
        end

        should 'have errors' do
          assert @feed.invalid?
          assert @feed.errors.on(:url)
          assert_equal 1, @feed.errors.on(:url).grep(/valid RSS/).length
        end
      end
    end


    context 'on #refresh' do
      context 'the feed cannot be found' do
        setup do
          stub_request(:get, @url).to_return(:status => 404)
        end

        should 'raise a FeedNotFound exception' do
          assert_raise(YelpFeed::FeedNotFound) { @feed.refresh }
        end
      end

      context 'when the feed is found' do
        context 'and is valid RSS' do
          should 'load the data' do
            @feed.refresh

            assert_equal @rss['rss']['channel']['item'].length,
              @feed.items.length

            @rss['rss']['channel']['item'].each_with_index do |item, i|
              assert_equal item['title'], @feed.items[i].title
              assert_equal item['description'], @feed.items[i].description
              assert_equal item['link'], @feed.items[i].url
              assert_equal Time.parse(item['pubDate']), @feed.items[i].published_at
            end
          end

          should 'set "refreshed_at"' do
            time = Time.now - 1.day
            @feed.refreshed_at = time
            @feed.save
            assert_equal time, @feed.refreshed_at

            @feed.refresh
            assert @feed.refreshed_at != time
          end
        end

        context 'and is not valid RSS' do
          setup do
            stub_request(:get, @url).to_return(
              :status  => 200,
              :body    => 'rss blah blah',
              :headers => { 'Content-Type' => 'text/plain' }
            )
          end

          should 'raise an InvalidFeed exception' do
            assert_raise(YelpFeed::InvalidFeed) { @feed.refresh }
          end
        end
      end
    end

  end
end
