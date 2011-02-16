class TwitterAccount < ActiveRecord::Base
  has_many :tweets, :dependent => :destroy

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, :with => /^[^@]/, :message => 'should not include the @ symbol'

  validate :username_exists

  def sync
    Twitter.user_timeline(username).each do |attrs|
      tweets.find_or_create_by_tweet_id(attrs.id_str) do |tweet|
        tweet.text      = attrs.text
        tweet.posted_at = attrs.created_at
      end
    end
  end


  private

  def username_exists
    begin
      Twitter.user(username) if username?
    rescue Twitter::NotFound
      errors.add(:username, 'is not a valid Twitter user')
    end
  end
end
