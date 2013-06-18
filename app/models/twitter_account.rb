class TwitterAccount < ActiveRecord::Base
  has_many :tweets, :dependent => :destroy

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :in => 1..15,
    :too_short => 'must be more than %{count} characters',
    :too_long  => 'must be %{count} or fewer characters'
  validates_format_of :username,
    :with    => /^[_A-Za-z0-9]{1,15}$/,
    :message => 'should only contain letters, numbers, and underscore. Do not include the @ symbol before the username'

  validate :username_exists

  def sync
    begin
      Twitter.user_timeline(username).each do |remote_tweet|
        tweets.find_or_create_by_tweet_id(remote_tweet.attrs[:id_str]) do |tweet|
          tweet.text      = remote_tweet.text
          tweet.posted_at = remote_tweet.created_at
        end
      end

      true
    rescue Twitter::Error::NotFound
      false
    rescue Twitter::Error => e
      log_bad_request('could not sync tweets', e)
    end
  end

  def typus_name
    username
  end


  private

  def username_exists
    begin
      if username? && errors.on(:username).blank? && !Twitter.user?(username)
        errors.add(:username, 'is not a valid Twitter user')
      end
    rescue Twitter::Error => e
      log_bad_request("could not validate username #{username} exists", e)
    end
  end

  def log_bad_request(message, e)
    #:nocov:
    HoptoadNotifier.notify(e)

    Rails.logger.error <<-END
======
TwitterAccount#sync error
------
  Error: #{message}

  Exception: #{e.message}

  Backtrace: #{e.backtrace}
======
    END
    #:nocov:
  end
end
