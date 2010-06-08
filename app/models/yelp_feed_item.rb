class YelpFeedItem < ActiveRecord::Base
  belongs_to :yelp_feed

  default_scope :order => 'published_at DESC'

  validates_presence_of :title,
    :url,
    :description,
    :published_at,
    :yelp_feed
end
