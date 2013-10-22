class Feed < ActiveRecord::Base
  class FeedNotFound < StandardError; end
  class InvalidFeed < StandardError; end

  has_many :items,
           :class_name => 'FeedItem',
           :dependent  => :destroy

  has_many :properties, :foreign_key => :local_info_feed_id

  before_validation :strip_whitespace

  validates_presence_of :name, :url

  validates_uniqueness_of :url

  validate_on_create :feed_valid?


  def typus_name
    name
  end

  def refresh!
    if !rss_fetcher.found?
      raise FeedNotFound, "Could not load feed: #{url}"
    end

    if !rss_fetcher.feed_valid?
      raise InvalidFeed, "Not a valid RSS feed: #{url}"
    end

    items.destroy_all

    rss_fetcher.items.each do |item|
      items << FeedItem.new({
        :title        => item['title'],
        :description  => Nokogiri::HTML(item['description']).content,
        :url          => item['link'],
        :published_at => item['pubDate'] || Time.now
      })
    end

    self.refreshed_at = Time.now

    save
  end

  def feed_valid?
    return if url.blank?

    if !rss_fetcher.found?
      errors.add(:url, "could not be found")
    elsif !rss_fetcher.feed_valid?
      errors.add(:url, 'is not a valid RSS feed')
    end
  end


  protected

  def rss_fetcher
    @rss_fetcher ||= Bozzuto::RssFetcher.new(url)
  end

  def strip_whitespace
    self.url = url.strip if url.present?
  end
end
