class FeedItem < ActiveRecord::Base
  belongs_to :feed

  named_scope :recent, :limit => 10
  default_scope :order => 'published_at DESC'

  validates_presence_of :title,
    :url,
    :description,
    :published_at,
    :feed
end
