class YelpFeed < ActiveRecord::Base
  has_many :items, :class_name => 'YelpFeedItem'

  validates_presence_of :url
  validates_uniqueness_of :url
end
