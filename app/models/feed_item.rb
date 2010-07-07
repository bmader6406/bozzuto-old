class FeedItem < ActiveRecord::Base
  belongs_to :feed

  default_scope :order => 'published_at DESC'

  validates_presence_of :title,
    :url,
    :description,
    :published_at,
    :feed
end
