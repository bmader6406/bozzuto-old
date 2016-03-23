require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  context "Tweet" do
    before do
      @account = TwitterAccount.new(username: 'TheBozzutoGroup')
      @account.save(validate: false)

      @tweet = Tweet.make(
        posted_at:       1.month.ago,
        twitter_account: @account,
        text:            "MySQL, y u do dis? \xF0\x9F\x98\x96"
      )
    end

    subject { @tweet }

    should belong_to(:twitter_account)

    should validate_presence_of(:text)
    should validate_presence_of(:posted_at)
    should validate_presence_of(:tweet_id)
    should validate_presence_of(:twitter_account)

    should validate_uniqueness_of(:tweet_id)

    context "scopes" do
      before do
        @tweets = (1..12).map do |i|
          Tweet.make(posted_at: Time.now - i.days, twitter_account: @account)
        end
      end

      describe ".recent" do
        it "returns the latest 10 tweets" do
          Tweet.recent.should == @tweets.first(10)
        end
      end

      describe ".latest" do
        it "returns the latest tweet" do
          Tweet.latest.should == @tweets.first
        end
      end
    end
  end
end
