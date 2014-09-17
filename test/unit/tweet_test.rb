require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  context 'A Tweet' do
    setup do
      @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
      @account.save(:validate => false)

      @tweet = Tweet.make :twitter_account => @account
    end

    subject { @tweet }

    should belong_to(:twitter_account)

    should validate_presence_of(:text)
    should validate_presence_of(:posted_at)
    should validate_presence_of(:tweet_id)
    should validate_presence_of(:twitter_account)

    should validate_uniqueness_of(:tweet_id)
  end

  context 'The Tweet class' do
    setup do
      @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
      @account.save(:validate => false)

      @tweets = (1..12).inject([]) do |array, i|
        array << Tweet.make(
          :posted_at       => Time.now - i.days,
          :twitter_account => @account
        )
      end
    end

    context 'when querying for recent tweets' do
      should 'return the latest 10 tweets' do
        Tweet.recent.should == @tweets.first(10)
      end
    end

    context 'when querying for the latest tweet' do
      should 'return the latest tweet' do
        Tweet.latest.should == @tweets.first
      end
    end
  end
end
