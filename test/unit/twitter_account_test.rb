require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase
  context 'A TwitterAccount' do
    setup do
      VCR.use_cassette('twitter_user_TheBozzutoGroup') do
        @account = TwitterAccount.make(:username => 'TheBozzutoGroup')
      end
    end

    subject { @account }

    should_have_many :tweets

    should_validate_presence_of :username
    should_validate_uniqueness_of :username

    context '#typus_name' do
      should 'return the username' do
        assert_equal @account.username, @account.typus_name
      end
    end

    context 'with a username' do
      context 'and Twitter API is rate limited' do
        setup do
          Twitter.expects(:user?).raises(Twitter::Error)
          @account.expects(:log_bad_request)

          @account.username = 'doh'
        end

        should 'catch the error' do
          assert_nothing_raised { @account.valid? }
        end
      end

      context 'that is not a Twitter user' do
        setup do
          @account.username = '5d234f'
        end

        should 'have an error on username' do
          VCR.use_cassette('twitter_user_5d234f') do
            assert !@account.valid?
          end

          assert_match /is not a valid Twitter user/, @account.errors.on(:username)
        end
      end

      context 'that is Twitter user' do
        setup { @account.username = 'TheBozzutoGroup' }

        should 'not have an error' do
          VCR.use_cassette('twitter_user_TheBozzutoGroup') do
            assert @account.valid?
          end

          assert_nil @account.errors.on(:username)
        end
      end

      context 'that has an @ at the start of the username' do
        setup do
          @account.stubs(:username_exists)
          @account.username = '@yaychris'
        end

        should 'have an error on username' do
          assert !@account.valid?
          assert_match /Do not include the @ symbol/,
            @account.errors.on(:username)
        end
      end

      context 'that has invalid characters' do
        setup do
          @account.stubs(:username_exists)
          @account.username = '!@#$ -=":>'
        end

        should 'have an error on username' do
          assert !@account.valid?
          assert_match /should only contain letters, numbers, and underscore/,
            @account.errors.on(:username)
        end
      end

      context 'that has more than 15 characters' do
        setup do
          @account.stubs(:username_exists)
          @account.username = 'a' * 16
        end

        should 'have an error on username' do
          assert !@account.valid?
          assert @account.errors.on(:username).detect { |e|
            e =~ /must be 15 or fewer characters/
          }
        end
      end
    end

    context 'when syncing' do
      setup do
        VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
          @tweets = Twitter.user_timeline('TheBozzutoGroup')
        end
      end

      context 'and no tweets exist' do
        should 'create all of the tweets' do
          assert_difference('@account.tweets.count', @tweets.count) {
            VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
              @account.sync
            end
          }

          @tweets.zip(@account.tweets).each do |expected, actual|
            assert_equal expected.text, actual.text
            assert_equal expected.attrs[:id_str], actual.tweet_id
          end
        end
      end

      context 'and some tweets already exist' do
        setup do
          @first = @tweets.first

          @account.tweets.find_or_create_by_tweet_id(@first.attrs[:id_str]) do |tweet|
            tweet.text      = @first.text
            tweet.posted_at = @first.created_at
          end
        end

        should 'only create the new tweets' do
          assert_difference('@account.tweets.count', @tweets.count - 1) {
            VCR.use_cassette('twitter_timeline_TheBozzutoGroup') do
              @account.sync
            end
          }

          @tweets.zip(@account.tweets).each do |expected, actual|
            assert_equal expected.text, actual.text
            assert_equal expected.attrs[:id_str], actual.tweet_id
          end
        end
      end

      context 'and the username is invalid' do
        setup do
          @account.username = '5d234f'
        end

        should 'return false' do
          VCR.use_cassette('twitter_timeline_5d234f') do
            assert !@account.sync
          end
        end
      end

      context 'and Twitter API is rate limited' do
        setup do
          Twitter.expects(:user_timeline).raises(Twitter::Error)
          @account.expects(:log_bad_request)

          @account.username = 'doh'
        end

        should 'catch the error' do
          assert_nothing_raised { @account.sync }
        end
      end

    end
  end
end
