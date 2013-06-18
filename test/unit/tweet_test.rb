require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  context 'A Tweet' do
    setup do
      @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
      @account.save(false)

      @tweet = Tweet.make :twitter_account => @account
    end

    subject { @tweet }

    should_belong_to :twitter_account

    should_validate_presence_of :text,
      :posted_at,
      :tweet_id,
      :twitter_account

    should_validate_uniqueness_of :tweet_id
  end

  context 'The Tweet class' do
    setup do
      @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
      @account.save(false)

      @tweets = (1..12).inject([]) do |array, i|
        array << Tweet.make(
          :posted_at       => Time.now - i.days,
          :twitter_account => @account
        )
      end
    end

    context 'when querying for recent tweets' do
      should 'return the latest 10 tweets' do
        assert_equal @tweets.first(10), Tweet.recent
      end
    end

    context 'when querying for the latest tweet' do
      should 'return the latest tweet' do
        assert_equal @tweets.first, Tweet.latest
      end
    end
  end
end
