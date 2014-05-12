require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase
  context "TwitterAccount" do
    subject {
      TwitterAccount.any_instance.stubs(:username_exists)
      TwitterAccount.make(:username => 'batman')
    }

    should_have_many :tweets

    should_validate_presence_of :username
    should_validate_uniqueness_of :username

    describe "#typus_name" do
      it "returns the username" do
        subject.typus_name.should == 'batman'
      end
    end

    describe "validating the username" do
      subject { TwitterAccount.new }

      context "Twitter API is rate limited" do
        before do
          Twitter.expects(:user?).raises(Twitter::Error::TooManyRequests)

          subject.username = 'doh'
        end

        it "catch the error" do
          expect {
            subject.valid?
          }.to_not raise_error
        end

        it "adds an error message" do
          subject.valid?

          subject.errors.on(:base).should == "There was a problem connecting to Twitter. Please try again later."
        end
      end

      context "user doesn't exist" do
        before do
          subject.username = '5d234f'
        end

        it "has an error on username" do
          VCR.use_cassette('twitter_user_5d234f') do
            subject.valid?.should == false
          end

          subject.errors.on(:username).should =~ /is not a valid Twitter user/
        end
      end

      context "username starts with @" do
        before do
          subject.stubs(:username_exists)
          subject.username = '@yaychris'
        end

        it "has an error on username" do
          subject.valid?.should == false

          subject.errors.on(:username).should =~ /Do not include the @ symbol/
        end
      end

      context "username has invalid characters" do
        before do
          subject.stubs(:username_exists)
          subject.username = '!@#$ -=":>'
        end

        it "has an error on username" do
          subject.valid?.should == false

          subject.errors.on(:username).should =~ /should only contain letters, numbers, and underscore/
        end
      end

      context "username has more than 15 characters" do
        before do
          subject.stubs(:username_exists)

          subject.username = 'a' * 16
        end

        it "has an error on username" do
          subject.valid?.should == false

          subject.errors.on(:username).detect { |e|
            e =~ /must be 15 or fewer characters/
          }.should be_present
        end
      end

      context "user does exist" do
        before do
          subject.username = 'TheBozzutoGroup'
        end

        it "doesn't have an error" do
          VCR.use_cassette('twitter_user_TheBozzutoGroup') do
            subject.valid?.should == true
          end

          subject.errors.on(:username).should == nil
        end
      end
    end

    describe "#latest_tweet" do
      before do
        TwitterAccount.any_instance.stubs(:username_exists)
        @account = TwitterAccount.make

        @tweet = @account.tweets.make(:text => "I'M BATMAN", :posted_at => Time.now - 100.years)
      end

      subject { @account }

      context "update not needed" do
        before do
          subject.next_update_at = Time.now + 1.hour
        end

        it "doesn't fetch any new tweets" do
          expect {
            subject.latest_tweet
          }.to_not change { subject.tweets(true).count }
        end

        it "returns the existing tweet" do
          subject.latest_tweet.should == @tweet
        end
      end

      context "update needed" do
        before do
          subject.next_update_at = Time.now - 1.hour

          VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
            @tweets = Twitter.user_timeline('TheBozzutoGroup')
          end
        end

        it "fetches the newest tweets" do
          expect {
            VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
              subject.latest_tweet
            end
          }.to change { subject.tweets(true).count }.by(20)
        end

        it "returns the newest tweet" do
          VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
            subject.latest_tweet.tweet_id.should == @tweets.first.attrs[:id_str]
          end
        end

        it "sets :next_update_at to the next update time" do
          VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
            subject.latest_tweet
          end

          subject.next_update_at.should be_within(1.0).of(Time.now + TwitterAccount::UPDATE_FREQUENCY)
        end
      end

      context "Twitter raises an exception" do
        before do
          subject.next_update_at = Time.now - 1.hour

          Twitter.expects(:user_timeline).raises(Twitter::Error::TooManyRequests)
        end

        it "doesn't fetch any new tweets" do
          expect {
            subject.latest_tweet
          }.to_not change { subject.tweets(true).count }
        end

        it "returns the existing tweet" do
          subject.latest_tweet.should == @tweet
        end

        it "sets :next_update_at to the next rate limit window" do
          subject.latest_tweet

          subject.next_update_at.should be_within(1.0).of(Time.now + TwitterAccount::RATE_LIMIT_WINDOW)
        end
      end
    end
  end
end
