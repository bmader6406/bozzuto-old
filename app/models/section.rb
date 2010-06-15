class Section < ActiveRecord::Base
  has_one :service, :order => 'position ASC'
  has_many :news_posts,
    :conditions => { :published => true },
    :order      => 'published_at DESC'

  validates_presence_of :title
  validates_uniqueness_of :title
end
