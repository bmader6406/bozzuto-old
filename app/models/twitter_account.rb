class TwitterAccount < ActiveRecord::Base
  UPDATE_FREQUENCY  = 2.hours
  RATE_LIMIT_WINDOW = 15.minutes

  class_attribute :credentials

  has_many :tweets, :dependent => :destroy

  validates_presence_of :username

  validates_uniqueness_of :username

  validates_length_of :username, :in => 1..15,
                      :too_short => 'must be more than %{count} characters',
                      :too_long  => 'must be %{count} or fewer characters'

  validates_format_of :username,
                      :with    => /\A[_A-Za-z0-9]{1,15}\z/,
                      :message => 'should only contain letters, numbers, and underscore. Do not include the @ symbol before the username'

  validate :username_exists, :on => :create

  before_create :set_next_update_at


  def self.client
    @client ||= Twitter::REST::Client.new(credentials.presence || {})
  end

  def client
    self.class.client
  end

  def typus_name
    username
  end

  def latest_tweet
    fetch_latest_tweet if needs_update?

    tweets.latest
  end

  def needs_update?
    Time.now > next_update_at
  end

  def fetch_latest_tweet
    begin
      client.user_timeline(username).each do |response|
        tweet = tweets.find_or_initialize_by(:tweet_id => response.id.to_s).tap do |tweet|
          tweet.text      = response.text
          tweet.posted_at = response.created_at
        end

        tweet.save
      end

      update_attribute(:next_update_at, Time.now + UPDATE_FREQUENCY)

    rescue Twitter::Error => e
      HoptoadNotifier.notify(e)

      # Reschedule for the next rate limit window
      update_attribute(:next_update_at, Time.now + RATE_LIMIT_WINDOW)
    end
  end


  private

  def username_exists
    begin
      if username? && errors[:username].blank? && !client.user?(username)
        errors.add(:username, 'is not a valid Twitter user')
      end

    rescue Twitter::Error => e
      HoptoadNotifier.notify(e)

      errors.add(:base, "There was a problem connecting to Twitter. Please try again later.")
    end
  end

  def set_next_update_at
    self.next_update_at = Time.now
  end
end
