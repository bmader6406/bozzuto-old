class YelpFeed < ActiveRecord::Base
  include HTTParty

  has_many :items,
    :class_name => 'YelpFeedItem',
    :dependent  => :destroy
  has_many :communities, :class_name => 'ApartmentCommunity'

  validates_presence_of :url
  validates_uniqueness_of :url


  def validate_on_create
    fetch_feed

    if @feed_data.code == 404
      errors.add(:url, 'could not be found')
    elsif !valid_rss_feed?
      errors.add(:url, 'is not a valid RSS feed')
    end
  end


  def refresh
    fetch_feed

    if @feed_data.code == 404
      raise FeedNotFound, "Could not find feed at #{url}"
    end

    if !valid_rss_feed?
      raise InvalidFeed, 'Not a valid RSS feed'
    end

    items.destroy_all

    @feed_data['rss']['channel']['item'].each do |item|
      items << YelpFeedItem.new({
        :title        => item['title'],
        :description  => item['description'],
        :url          => item['link'],
        :published_at => item['pubDate']
      })
    end

    self.refreshed_at = Time.now
    save
  end


  class FeedNotFound < StandardError; end
  class InvalidFeed < StandardError; end

  class Parser < HTTParty::Parser
    SupportedFormats = {
      'application/rss+xml' => :xml,
      'text/xml'            => :xml
    }
  end

  parser Parser


  protected

  def fetch_feed
    @feed_data = YelpFeed.get(url)
  end

  def valid_rss_feed?
    @feed_data.is_a?(Hash) && @feed_data['rss'].present?
  end
end
