class Tweet < ActiveRecord::Base
  belongs_to :twitter_account

  validates_presence_of :text,
                        :posted_at,
                        :tweet_id,
                        :twitter_account

  validates_uniqueness_of :tweet_id

  scope :recent, :limit => 10

  default_scope :order => 'posted_at DESC'

  delegate :username, :to => :twitter_account

  def self.latest
    recent.first
  end
end
