class Tweet < ActiveRecord::Base

  belongs_to :twitter_account

  before_save :strip_emojis

  scope :recent, -> { limit(10) }

  default_scope -> { order(posted_at: :desc) }

  validates_presence_of :text,
                        :posted_at,
                        :tweet_id,
                        :twitter_account

  validates_uniqueness_of :tweet_id

  delegate :username, :to => :twitter_account

  def self.latest
    recent.first
  end

  private

  def strip_emojis
    self.text = Emoji.strip(text)
  end
end
