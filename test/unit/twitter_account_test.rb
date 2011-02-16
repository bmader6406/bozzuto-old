require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase
  context 'A TwitterAccount' do
    setup { @account = TwitterAccount.make }

    subject { @account }

    should_have_many :tweets

    should_validate_presence_of :username
    should_validate_uniqueness_of :username

    context 'with a username' do
      context 'that is not a Twitter user' do
        setup do
          url = 'https://api.twitter.com/1/users/show.json?screen_name=doh'
          stub_request(:get, url).to_return(
            :status => 404,
            :body   => '{"request":"\/1\/users\/show.json?screen_name=doh","error":"Not found"}'
          )

          @account.username = 'doh'
        end

        should 'have an error on username' do
          assert !@account.valid?
          assert_match /is not a valid Twitter user/, @account.errors.on(:username)
        end
      end

      context 'that is Twitter user' do
        setup { @account.username = 'TheBozzutoGroup' }

        should 'not have an error' do
          assert @account.valid?
          assert_nil @account.errors.on(:username)
        end
      end
    end

    context 'when syncing' do
      setup do
        @tweets = Twitter.user_timeline(@account.username)
      end

      context 'and no tweets exist' do
        should 'create all of the tweets' do
          assert_difference('@account.tweets.count', @tweets.count) {
            @account.sync
          }

          @tweets.zip(@account.tweets).each do |expected, actual|
            assert_equal expected.text, actual.text
            assert_equal expected.id_str, actual.tweet_id
          end
        end
      end

      context 'and some tweets already exist' do
        setup do
          @first = @tweets.first

          @account.tweets.find_or_create_by_tweet_id(@first.id_str) do |tweet|
            tweet.text      = @first.text
            tweet.posted_at = @first.created_at
          end
        end

        should 'only create the new tweets' do
          assert_difference('@account.tweets.count', @tweets.count - 1) {
            @account.sync
          }

          @tweets.zip(@account.tweets).each do |expected, actual|
            assert_equal expected.text, actual.text
            assert_equal expected.id_str, actual.tweet_id
          end
        end
      end
    end
  end
end
